local BasePlugin = require "kong.plugins.base_plugin"
local singletons = require "kong.singletons"
local constants = require "kong.constants"
local meta = require "kong.meta"
local cjson = require "cjson.safe"


local kong = kong
local server_header = meta._SERVER_TOKENS


local DEFAULT_RESPONSE = {
  [300] = "Multiple Choices",
  [301] = "Moved Permanently",
  [302] = "Found",
  [303] = "See Other",
  [304] = "Not Modified",
  [305] = "Use Proxy",
  [306] = "Switch Proxy",
  [307] = "Temporary Redirect",
  [308] = "Permanent Redirect",
}


local RedirectHandler = BasePlugin:extend()


RedirectHandler.PRIORITY = 2
RedirectHandler.VERSION = "0.2.0"


function RedirectHandler:new()
  RedirectHandler.super.new(self, "redirect")
end


function RedirectHandler:access(conf)
  RedirectHandler.super.access(self)

  local content      = conf.body
  local content_type = conf.content_type

  if not content then
    local encoded, err
    encoded, err = cjson.encode({ message = conf.message or DEFAULT_RESPONSE[status] })
    if encoded then
      content = encoded
    else
      kong.log.err("could not encode value: ", err)
      content = ""
    end
    content_type = nil -- reset to the default 'application/json'
  end

  if not content_type then
    content_type = "application/json; charset=utf-8"
  end

  local headers = {
    ["Content-Type"] = conf.content_type,
  }

  if singletons.configuration.enabled_headers[constants.HEADERS.SERVER] then
    headers[constants.HEADERS.SERVER] = server_header
  end

  local location       = conf.location
  local append_req_uri = conf.append_request_uri_to_location
  local append_qs      = conf.query_string_to_location

  if location then
    if append_req_uri then
      location = location .. kong.request.get_path()
    elseif append_qs then
      location = location .. "?" .. kong.request.get_raw_query()
    end
    header["Location"] = location
  end

  return kong.response.exit(conf.status_code, content, headers)
end


return RedirectHandler
