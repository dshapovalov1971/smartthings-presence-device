local test = require 'integration_test'
require '../env'
local caps = require 'st.capabilities'
require 'st.capabilities.generated.types.PresenceState'
local lu = require('luaunit')
local http = (require 'cosock').asyncify 'socket.http'
local ltn12 = require 'ltn12'
local mockDeviceTable = {
  ['00:04:20:ef:e0:2f']="HarmonyHub",
  ['00:80:92:8c:df:d1']="BRW0080928CDFD1",
  ['10:59:32:71:bd:6c']="TVRoomRoku",
  ['18:b4:30:bb:65:c3']="09AA01AC52160U70",
  ['18:b4:30:bb:bc:90']="09AA01AC53160FAW",
  ['18:b4:30:cf:2c:13']="09AA01RC321700CN",
  ['62:78:a5:f5:72:fa']="DSH",
  ['6a:2a:ef:27:d1:05']="SM-R860",
  ['ac:ae:19:ba:00:8f']="Basement",
  ['c0:ee:40:8e:11:f0']="MyArcticSpa0",
  ['d4:63:c6:62:8b:23']="android-5ba69c37733ed8e8",
  ['e4:fd:45:d3:22:e1']="LAPTOP-VF7ADLII",
}

TestRouter = {}
  http.request = function(p)
    if type(p) == 'string' then
      lu.assertEquals(p, RouterUrl)
      return 1, 200, {['set-cookie'] = 'cookie'}
    else
      lu.assertEquals(p.url, RouterUrl)
      lu.assertEquals(p.user, RouterUsername)
      lu.assertEquals(p.password, RouterPassword)
      lu.assertEquals(p.headers, { cookie = 'cookie' })
      ltn12.pump.all(ltn12.source.string([[
        }
            
        function InitAvailableWiredTagValue()
        {
          /* # (td) , Status, IP Address (td), MAC Address(td), Device Name (td) */
            var TableTagValueList = '4|1|192.168.0.24|c8:b8:2f:86:a5:21|eero|1|192.168.0.35|7c:72:e4:90:26:08|--|1|192.168.0.42|00:14:ee:03:66:b7|MyCloud-XEC16K|1|192.168.0.108<br>2601:19b:c401:59b0:478b:7f77:e8f7:99d9|5c:96:66:dc:88:68|--|';

            /*var TableTagValueList = "5" +
                                        "|1|192.168.0.1|00:11:22:33:44:55|NICK-PC" +
                                        "|1|192.168.0.100|11:22:cc:44:55:66|TERRY-PC" + 
                                        "|1|192.168.0.112|11:22:33:bb:55:66|test3" + 
                                        "|1|192.168.0.131|11:22:33:44:aa:66|test4" + 
                                        "|1|192.168.0.33|01:f1:ea:aa:bb:31|aaa|";
            */
            return TableTagValueList.split("|");
        }
        function InitAvailableWireless2GTagValue()
          {
            /* SSID (td) , Status, IP Address (td), MAC Address(td), Device Name (td) */
              var TableTagValueList = '9|DSHc|1|192.168.0.34|0c:1c:57:a9:01:0b|Ring-a9010b|DSHc|1|192.168.0.38|30:45:11:44:80:31|Ring-448031|DSHc|1|192.168.0.39|f0:45:da:3c:cd:37|Ring-3ccd37|DSHc|1|192.168.0.33|34:20:03:57:2f:9c||DSHc|1|192.168.0.23|34:20:03:57:18:e1||DSHc|1|192.168.0.29|34:20:03:2d:d5:74||DSHc|1|192.168.0.17|00:04:20:ef:e0:2f|HarmonyHub|DSHc|1|192.168.0.28|ac:ae:19:ba:00:8f|Basement|DSHc|1|192.168.0.9|00:80:92:8c:df:d1|BRW0080928CDFD1|';
          
              /*var TableTagValueList = "5" +
                                          "|NetGear-Emerson|1|192.168.0.1|00:11:22:33:44:55|NICK-PC" +
                                          "|NetGear-Emerson|1|192.168.0.100|11:22:cc:44:55:66|TERRY-PC" + 
                                          "|NetGear-Emerson|1|192.168.0.112|11:22:33:bb:55:66|test3" + 
                                          "|NetGear-Emerson|1|192.168.0.131|11:22:33:44:aa:66|test4" + 
                                          "|NetGear-Emerson|1|192.168.0.33|01:f1:ea:aa:bb:31|aaa|";
              */
              return TableTagValueList.split("|");
          }
        function InitAvailableGuest2GTagValue()
          {
            /* SSID (td) , Status, IP Address (td), MAC Address(td), Device Name (td) */
              var TableTagValueList = '0|';
          
              /*var TableTagValueList = "5" +
                                          "|NetGear-Emerson|1|192.168.0.1|00:11:22:33:44:55|NICK-PC" +
                                          "|NetGear-Emerson|1|192.168.0.100|11:22:cc:44:55:66|TERRY-PC" + 
                                          "|NetGear-Emerson|1|192.168.0.112|11:22:33:bb:55:66|test3" + 
                                          "|NetGear-Emerson|1|192.168.0.131|11:22:33:44:aa:66|test4" + 
                                          "|NetGear-Emerson|1|192.168.0.33|01:f1:ea:aa:bb:31|aaa|";
              */
              return TableTagValueList.split("|");
          }
        function InitAvailableWireless5GTagValue()
          {
            /* SSID (td) , Status, IP Address (td), MAC Address(td), Device Name (td) */
              var TableTagValueList = '12|DSHc-5G|1|192.168.0.14<br>2601:19b:c401:59b0:f155:cd68:8c62:457|6a:2a:ef:27:d1:05|SM-R860|DSHc-5G|1|192.168.0.32<br>2601:19b:c401:59b0:f136:51d6:8264:a678|62:78:a5:f5:72:fa|DSH|DSHc-5G|1|192.168.0.12<br>2601:19b:c401:59b0:dd4f:a49:e0a7:baf0|52:20:fc:0c:df:53||DSHc-5G|1|192.168.0.16|18:b4:30:bb:bc:90|09AA01AC53160FAW|DSHc-5G|1|192.168.0.36<br>2601:19b:c401:59b0:8194:a77c:2a38:a149|28:6d:97:70:0c:79|hubv3-3011000927|DSHc-5G|1|192.168.0.31<br>2601:19b:c401:59b0:d388:26d6:8a1b:2572|e4:fd:45:d3:22:e1|LAPTOP-VF7ADLII|DSHc-5G|1|192.168.0.19<br>2601:19b:c401:59b0:cc61:8ae4:1468:5f4b|d4:63:c6:62:8b:23|android-5ba69c37733ed8e8|DSHc-5G|1|192.168.0.25|e0:4f:43:a4:2a:35|RingPro-35|DSHc-5G|1|192.168.0.54|18:b4:30:cf:2c:13|09AA01RC321700CN|DSHc-5G|1|192.168.0.20|18:b4:30:bb:65:c3|09AA01AC52160U70|DSHc-5G|1|192.168.0.11<br>2601:19b:c401:59b0:c2ee:40ff:fe8e:11f0|c0:ee:40:8e:11:f0|MyArcticSpa0|DSHc-5G|1|192.168.0.98|10:59:32:71:bd:6c|TVRoomRoku|';
          
              /*var TableTagValueList = "5" +
                                          "|NetGear-5G-Emerson|1|192.168.0.1|00:11:22:33:44:55|NICK-PC" +
                                          "|NetGear-5G-Emerson|1|192.168.0.100|11:22:cc:44:55:66|TERRY-PC" + 
                                          "|NetGear-5G-Emerson|1|192.168.0.112|11:22:33:bb:55:66|test3" + 
                                          "|NetGear-5G-Emerson|1|192.168.0.131|11:22:33:44:aa:66|test4" + 
                                          "|NetGear-5G-Emerson|1|192.168.0.33|01:f1:ea:aa:bb:31|aaa|";
              */
              return TableTagValueList.split("|");
          }
        ]]), p.sink)
    end
  end
  local router = require('router')

  function TestRouter.test()
    lu.assertEquals(router.connected_devices(), mockDeviceTable)
  end


TestDriver = {}
  function TestDriver.test()
  end

  
TestInit = {}
  local get_state_cnt = 0
  local emit_present_cnt = 0
  local emit_non_present_cnt = 0
  local mockUnitDevice = setmetatable({}, {
    __call = function (_, id, label, state)
      return {
        type = 'LAN',
        device_network_id = id,
        label = label,
        profile = 'network.presence',
        get_latest_state = function()
          get_state_cnt = get_state_cnt + 1
          return state.value
        end,
        emit_event = function(state)
          if state.value.value == 'present' then
            emit_present_cnt = emit_present_cnt + 1
          else
            emit_non_present_cnt = emit_non_present_cnt + 1
          end
        end,
      }
    end
  })
  local scheduled_function
  local driver_template
  local call_on_schedule_interval = CheckInterval
  local mockUnitDriver
  local try_create_device_calls = {}
  local cancel_timer_cnt = 0
  local try_create_device_result
  package.loaded['st.driver'] = setmetatable({}, {
    __call = function (_, name, template)
      driver_template = template
      lu.assertEquals(name, 'Network Presence Driver')
      mockUnitDriver = {
        call_on_schedule = function(_, i, f)
          lu.assertEquals(i, call_on_schedule_interval)
          scheduled_function = f
          return '1234567'
        end,
        run = function () end,
        get_devices = function ()
          return {
            mockUnitDevice('d4:63:c6:62:8b:23', 'android-5ba69c37733ed8e8', caps.presenceSensor.presence.present()),
            mockUnitDevice('62:78:a5:f5:72:fa', 'DSH', caps.presenceSensor.presence.not_present()),
            mockUnitDevice('00:01:02:f5:72:fa', 'iphone', caps.presenceSensor.presence.present()),
          }
        end,
        try_create_device = function (_, p)
          table.insert(try_create_device_calls, p)
          return try_create_device_result
        end,
        cancel_timer = function (_, h)
          lu.assertEquals(h, '1234567')
          cancel_timer_cnt = cancel_timer_cnt + 1
        end,
      }
      return mockUnitDriver
    end,
  })
  package.loaded['router'] = {
    connected_devices = function ()
      return mockDeviceTable
    end
  }
  require('init')

  function TestInit.test()
    scheduled_function()
    lu.assertEquals(get_state_cnt, 3)
    lu.assertEquals(emit_present_cnt, 1)
    lu.assertEquals(emit_non_present_cnt, 1)

    call_on_schedule_interval = 5
    try_create_device_result = false
    lu.assertError(driver_template.discovery, mockUnitDriver, nil, function()
      return true
    end)

    try_create_device_result = true
    local cnt = 3
    driver_template.discovery(mockUnitDriver, nil, function()
      cnt = cnt - 1
      return cnt > 0 and true or false
    end)
    lu.assertItemsEquals(try_create_device_calls, {
      {
          device_network_id="18:b4:30:cf:2c:13",
          label="09AA01RC321700CN",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="00:04:20:ef:e0:2f",
          label="HarmonyHub",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="e4:fd:45:d3:22:e1",
          label="LAPTOP-VF7ADLII",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="10:59:32:71:bd:6c",
          label="TVRoomRoku",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="6a:2a:ef:27:d1:05",
          label="SM-R860",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="18:b4:30:bb:bc:90",
          label="09AA01AC53160FAW",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="18:b4:30:bb:65:c3",
          label="09AA01AC52160U70",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="00:80:92:8c:df:d1",
          label="BRW0080928CDFD1",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="ac:ae:19:ba:00:8f",
          label="Basement",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="c0:ee:40:8e:11:f0",
          label="MyArcticSpa0",
          profile="network.presence",
          type="LAN"
      },
    })
    try_create_device_calls = {}
    scheduled_function()
    lu.assertItemsEquals(try_create_device_calls, {})
    scheduled_function()
    lu.assertEquals(cancel_timer_cnt, 1)
  end


os.exit(lu.LuaUnit.run('-v'))
