local cosock = require 'cosock'
local http = cosock.asyncify "socket.http"
local ltn12 = require 'ltn12'
local base64 = require('st.base64')
require 'env'
require 'env_secret'

local Router = {}
  local XSRF_TOKEN

  function Router.connected_devices()
    local RouterUrl = 'http://192.168.0.1/AttachedDevices_new.htm'
    local rc = {}
    local resp = ''
    for _ = 1, 10 do
      if not XSRF_TOKEN then
        XSRF_TOKEN = ({ http.request(RouterUrl)})[3]['set-cookie']
      end
      local _, code = http.request {
        url = RouterUrl,
        sink = ltn12.sink.table(rc),
        headers = {
          authorization = 'Basic '..base64.encode(RouterUsername..':'..RouterPassword),
          cookie = XSRF_TOKEN,
          connection = 'keep-alive',
          ['cache-control'] = 'max-age=0',
          ['user-agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 Edg/112.0.1722.48',
          accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
          ['accept-encoding'] = 'gzip, deflate',
          ['accept-language'] = 'en-US,en;q=0.9',
        },
        create = function()
          local sock = cosock.socket.tcp()
          sock:settimeout(5)
          return sock
        end,
      }

      if code == 401 then
        XSRF_TOKEN = nil
      elseif code == 200 then
        resp = table.concat(rc)
        if resp:find('</html>') then
          break
        end
      end
    end
    local r = {}
    for m in (resp):gmatch "var TableTagValueList = (%b'');" do
      local l, w, p, mac = -1, true, nil, nil;
      for v in (m:gsub('\'', ''):gsub('||', '| |')):gmatch '[^|]+' do
        if l < 0 then
          l = tonumber(v) or l;
          p = 0;
        elseif p > 0 or tonumber(v) then
          if p == 2 then
            r[v] = ''
            mac = v
          elseif p == 3 then
            r[mac] = not w and ((v == ' ' or v == '') and mac
                    or v~= '--'
                    and not v:find('Ring-', 1, true)
                    and not v:find('DESKTOP-', 1, true)
                    and not v:find('RingPro-', 1, true)
                    and not v:find('hubv3-', 1, true)
                    and not v:find('MyQ-', 1, true)
                    and not v:find('MyCloud-', 1, true)
                    and v) or nil
            p = -1
            w = true
          end
          p = p + 1
        else
          w = false
        end
      end
    end

    assert(next(r), 'device list cannot be empty')
    return r
  end

return Router
