local BasePlugin = require "kong.plugins.base_plugin"
local singletons = require "kong.singletons"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local meta = require "kong.meta"
local cjson = require "cjson.safe"


local ngx = ngx

local req_get_uri_args = ngx.req.get_uri_args
local ngx_log = ngx.log
-- local DEBUG = ngx.DEBUG


local server_header = meta._SERVER_TOKENS


local RedirectHandler = BasePlugin:extend()


RedirectHandler.PRIORITY = 2
RedirectHandler.VERSION = "0.1.0"


local function flush(ctx)
  ctx = ctx or ngx.ctx

  local response = ctx.delayed_response

  local status         = response.status_code
  local content        = response.content
  local content_type   = response.content_type
  local location       = response.location
  local append_req_uri = response.append_req_uri
  local append_qs      = response.append_qs

  if not content_type then
    content_type = "application/json; charset=utf-8";
  end

  ngx.status = status

  if singletons.configuration.enabled_headers[constants.HEADERS.SERVER] then
    ngx.header[constants.HEADERS.SERVER] = server_header
  else
    ngx.header[constants.HEADERS.SERVER] = nil
  end

  -- ngx_log(DEBUG, "Nginx request URI: [", ngx.var.request_uri, "]")
  -- ngx_log(DEBUG, "Nginx query string: [", ngx.var.query_string, "]")
  -- ngx_log(DEBUG, "Configured location: [", location, "]")

  if location then
    if append_req_uri then
      location = location .. ngx.var.request_uri
    elseif append_qs then
      location = location .. "?" .. ngx.var.query_string
    end
    ngx.header["Location"] = location
  end

  ngx.header["Content-Type"]   = content_type
  ngx.header["Content-Length"] = #content
  ngx.print(content)

  return ngx.exit(status)
end


function RedirectHandler:new()
  RedirectHandler.super.new(self, "redirect")
end


function RedirectHandler:access(conf)
  RedirectHandler.super.access(self)

  local message = conf.message

  local content, content_type
  if not message then
    content = conf.body
    content_type = conf.content_type
  else
    local encoded, err
    encoded, err = cjson.encode({message = message})
    if encoded then
      content = encoded
    else
      ngx_log(ngx.ERR, "could not encode value: ", err)
      content = ""
    end
    content_type = nil -- default is "application/json"
  end

  local ctx = ngx.ctx

  if not ctx.delay_response then
    ngx_log(ngx.ERR, "failed at redirecting: response is not delayed")
  end
  if ctx.delayed_response then
    ngx_log(ngx.ERR, "failed at redirecting: ctx.delayed_response is already set")
  end

  ctx.delayed_response = {
    status_code    = conf.status_code,
    message        = message,
    content        = content,
    content_type   = content_type,
    location       = conf.location,
    append_req_uri = conf.append_request_uri_to_location,
    append_qs      = conf.query_string_to_location,
  }
  -- ngx_log(DEBUG, "Delayed response set. content: [", content, "]")

  ctx.delayed_response_callback = flush
  return
end


return RedirectHandler
