local BasePlugin = require "kong.plugins.base_plugin"
local singletons = require "kong.singletons"
local constants = require "kong.constants"
local meta = require "kong.meta"


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

  local status       = conf.status_code
  local content      = conf.body
  local content_type = conf.content_type

  if not content then
    content = { ["message"] = conf.message or DEFAULT_RESPONSE[status] }
    content_type = nil -- reset to the default 'application/json'
  end

  if not content_type then
    content_type = "application/json; charset=utf-8"
  end

  local headers = {
    ["Content-Type"] = content_type,
  }

  if singletons.configuration.enabled_headers[constants.HEADERS.SERVER] then
    headers[constants.HEADERS.SERVER] = server_header
  end

  local location = conf.location

  if location then
    if conf.append_request_uri_to_location then
      location = location .. kong.request.get_path()
    end
    if conf.append_query_string_to_location then
      location = location .. "?" .. kong.request.get_raw_query()
    end
    headers["Location"] = location
  end

  -- kong.log.debug("Nginx request URI: [", kong.request.get_path(), "]")
  -- kong.log.debug("Nginx query string: [", kong.request.get_raw_query(), "]")
  -- kong.log.debug("Computed content: [", content, "]")
  -- kong.log.debug("Configured location: [", location, "]")
  -- kong.log.debug("Computed response headers: [", headers, "]")

  return kong.response.exit(status, content, headers)
end


return RedirectHandler
