local http = (require 'cosock').asyncify "socket.http"
local ltn12 = require 'ltn12'
require '../env'

local Router = {}

  function Router.connected_devices()
    local rc = {}
    http.request {
      url = RouterUrl,
      sink = ltn12.sink.table(rc),
      user = RouterUsername,
      password = RouterPassword,
      headers = { cookie = ({ http.request(RouterUrl) })[3]['set-cookie'] },
    }
    local r = {}
    for m in (table.concat(rc)):gmatch "var TableTagValueList = (%b'');" do
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
            r[mac] = not w and v ~= ' ' and v ~= '' and v~= '--'
                    and not v:find('Ring-', 1, true)
                    and not v:find('DESKTOP-', 1, true)
                    and not v:find('RingPro-', 1, true)
                    and not v:find('hubv3-', 1, true)
                    and not v:find('MyQ-', 1, true)
                    and not v:find('MyCloud-', 1, true)
                    and v or nil
            p = -1
            w = true
          end
          p = p + 1
        else
          w = false
        end
      end
    end
    return r
  end

return Router
