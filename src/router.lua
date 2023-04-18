local cosock = require "cosock"
local http = cosock.asyncify "socket.http"
local ltn12 = require 'ltn12'

local Router = {}

function Router.connected_devices()
  local url = 'http://192.168.0.1/AttachedDevices_new.htm'
  local rc = {}
  http.request {
    url = url,
    sink = ltn12.sink.table(rc),
    user = 'admin',
    password = 'xxxxx',
    headers = { cookie = ({ http.request(url) })[3]['set-cookie'] },
  }
  local r = {}
  for m in (table.concat(rc)):gmatch "var TableTagValueList = (%b'');" do
    local l = -1;
    local p, mac;
    for v in (m:gsub('\'', ''):gsub('||', '| |')):gmatch '[^|]+' do
      if l < 0 then
        l = tonumber(v) or l;
        p = 0;
      elseif p > 0 or tonumber(v) then
        if p == 2 then
          r[v] = ''
          mac = v
        elseif p == 3 then
          r[mac] = v == ' ' and '' or v
          p = -1
        end
        p = p + 1
      end
    end
  end
  return r
end

return Router
