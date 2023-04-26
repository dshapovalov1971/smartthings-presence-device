local test = require 'integration_test'
require 'env'
require 'env_secret'
local caps = require 'st.capabilities'
require 'st.capabilities.generated.types.PresenceState'
local lu = require('luaunit')
local http = (require 'cosock').asyncify 'socket.http'
local ltn12 = require 'ltn12'
local base64 = require('st.base64')
print(RouterUsername)
print(RouterPassword)

local present = caps.presenceSensor.presence.present()
local not_present = caps.presenceSensor.presence.not_present()
local RouterUrl = 'http://192.168.0.1/AttachedDevices_new.htm'
local mockDeviceTable = {
  ['00:04:20:ef:e0:2f']="HarmonyHub",
  ['00:80:92:8c:df:d1']="BRW0080928CDFD1",
  ['10:59:32:71:bd:6c']="TVRoomRoku",
  ['18:b4:30:bb:65:c3']="09AA01AC52160U70",
  ['18:b4:30:bb:bc:90']="09AA01AC53160FAW",
  ['18:b4:30:cf:2c:13']="09AA01RC321700CN",
  ['34:20:03:2d:d5:74']="34:20:03:2d:d5:74",
  ['34:20:03:57:18:e1']="34:20:03:57:18:e1",
  ['34:20:03:57:2f:9c']="34:20:03:57:2f:9c",
  ['52:20:fc:0c:df:53']="52:20:fc:0c:df:53",
  ['62:78:a5:f5:72:fa']="DSH",
  ['6a:2a:ef:27:d1:05']="SM-R860",
  ['ac:ae:19:ba:00:8f']="Basement",
  ['c0:ee:40:8e:11:f0']="MyArcticSpa0",
  ['d4:63:c6:62:8b:23']="android-5ba69c37733ed8e8",
  ['e4:fd:45:d3:22:e1']="LAPTOP-VF7ADLII",
}
local httpCode = 200
local mockRouterResponse = [[
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
    }</html>
]]
http.request = function(p)
  if type(p) == 'string' then
    lu.assertEquals(p, RouterUrl)
    return 1, 200, {['set-cookie'] = 'cookie'}
  else
    lu.assertEquals(p.url, RouterUrl)
    lu.assertEquals(p.headers, {
      authorization = 'Basic '..base64.encode(RouterUsername..':'..RouterPassword),
      cookie = 'cookie',
      connection = 'keep-alive',
      ['cache-control'] = 'max-age=0',
      ['user-agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 Edg/112.0.1722.48',
      accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
      ['accept-encoding'] = 'gzip, deflate',
      ['accept-language'] = 'en-US,en;q=0.9',
    })
    local sock = p.create()
    lu.assertEquals(sock.class, 'tcp{master}')
    lu.assertEquals(sock.timeout, 5)
    ltn12.pump.all(ltn12.source.string(mockRouterResponse), p.sink)
    return 1, httpCode
  end
end

TestRouter = {}
  function TestRouter:setUp()
    self.router = require('router')
  end
  function TestRouter:test()
    lu.assertEquals(self.router.connected_devices(), mockDeviceTable)
  end
  function TestRouter:tearDown()
    package.loaded['router'] = nil
  end


TestInit = {}
  function TestInit:setUp()
    self.call_on_schedule_interval = CheckInterval
    self.try_create_device_calls = {}
    self.cancel_timer_cnt = 0
    self.get_state_cnt = 0
    self.emit_present_cnt = 0
    self.emit_non_present_cnt = 0
    self.mockUnitDevice = setmetatable({}, {
      __call = function (_, id, label, state)
        return {
          type = 'LAN',
          device_network_id = id,
          label = label,
          profile = 'network.presence',
          get_latest_state = function(_, component_id, capability_id, attribute_name)
            lu.assertEquals(component_id, 'main')
            lu.assertEquals(capability_id, 'presenceSensor')
            lu.assertEquals(attribute_name, 'presence')
            self.get_state_cnt = self.get_state_cnt + 1
            return state.value.value
          end,
          emit_event = function(_, state)
            if state.value.value == 'present' then
              self.emit_present_cnt = self.emit_present_cnt + 1
            else
              self.emit_non_present_cnt = self.emit_non_present_cnt + 1
            end
          end,
        }
      end
    })
    package.loaded['st.driver'] = setmetatable({}, {
      __call = function (_, name, template)
        self.driver_template = template
        lu.assertEquals(name, 'Network Presence Driver')
        self.mockUnitDriver = {
          call_on_schedule = function(_, i, f)
            lu.assertEquals(i, self.call_on_schedule_interval)
            self.scheduled_function = f
            return '1234567'
          end,
          call_with_delay = function(_, i, f)
            lu.assertEquals(i, 0)
            self.scheduled_function = f
            return '7654321'
          end,
          run = function () end,
          get_devices = function ()
            return {
              self.mockUnitDevice('d4:63:c6:62:8b:23', 'android-5ba69c37733ed8e8', present),
              self.mockUnitDevice('62:78:a5:f5:72:fa', 'DSH', not_present),
              self.mockUnitDevice('00:01:02:f5:72:fa', 'iphone', present),
            }
          end,
          try_create_device = function (_, p)
            table.insert(self.try_create_device_calls, p)
            return self.try_create_device_result
          end,
          cancel_timer = function (_, h)
            lu.assertEquals(h, '1234567')
            self.cancel_timer_cnt = self.cancel_timer_cnt + 1
          end,
        }
        return self.mockUnitDriver
      end,
    })
    package.loaded['router'] = {
      connected_devices = function ()
        return mockDeviceTable
      end
    }
    require('init')
  end
  function TestInit:test()
    self.scheduled_function()
    lu.assertEquals(self.get_state_cnt, 3)
    lu.assertEquals(self.emit_present_cnt, 1)
    lu.assertEquals(self.emit_non_present_cnt, 1)

    self.call_on_schedule_interval = 5
    self.try_create_device_result = false
    lu.assertError(self.driver_template.discovery, self.mockUnitDriver, nil, function()
      return true
    end)

    self.try_create_device_result = true
    local cnt = 3
    self.driver_template.discovery(self.mockUnitDriver, nil, function()
      cnt = cnt - 1
      return cnt > 0 and true or false
    end)
    lu.assertItemsEquals(self.try_create_device_calls, {
      {
          device_network_id="e4:fd:45:d3:22:e1",
          label="LAPTOP-VF7ADLII",
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
          device_network_id="c0:ee:40:8e:11:f0",
          label="MyArcticSpa0",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="34:20:03:57:18:e1",
          label="34:20:03:57:18:e1",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="34:20:03:57:2f:9c",
          label="34:20:03:57:2f:9c",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="18:b4:30:cf:2c:13",
          label="09AA01RC321700CN",
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
          device_network_id="00:04:20:ef:e0:2f",
          label="HarmonyHub",
          profile="network.presence",
          type="LAN"
      },
      {
          device_network_id="34:20:03:2d:d5:74",
          label="34:20:03:2d:d5:74",
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
          device_network_id="18:b4:30:bb:65:c3",
          label="09AA01AC52160U70",
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
          device_network_id="52:20:fc:0c:df:53",
          label="52:20:fc:0c:df:53",
          profile="network.presence",
          type="LAN"
      },
  })
    self.try_create_device_calls = {}
    self.scheduled_function()
    lu.assertItemsEquals(self.try_create_device_calls, {})
    self.scheduled_function()
    lu.assertEquals(self.cancel_timer_cnt, 1)
  end
  function TestInit:tearDown()
    package.loaded['st.driver'] = nil
    package.loaded['router'] = nil
    package.loaded['init'] = nil
  end


TestDriver = {}
  function TestDriver:setUp()
    self.driver = require('st.driver')
    self.mockRouterResponse = mockRouterResponse
    self.profile = {
      components = { main = {
          capabilities = {{ id = 'presenceSensor', version = 1 }},
          categories = {{ name = 'PresenceSensor' }},
          id = 'main'
      }},
      preferences = {}
    }
    self.mockDevice1 = test.mock_device.build_test_generic_device({
      profile = self.profile,
      device_network_id = 'd4:63:c6:62:8b:23',
      label = 'android-5ba69c37733ed8e8'
    })
    self.mockDevice2 = test.mock_device.build_test_generic_device({
      profile = self.profile,
      device_network_id = '62:78:a5:f5:72:fa',
      label = 'DSH'
    })
    self.mockDevice3 = test.mock_device.build_test_generic_device({
      profile = self.profile,
      device_network_id = '00:01:02:f5:72:fa',
      label = 'iphone'
    })
end
  function TestDriver:test()
    test.set_test_init_function(function ()
      test.mock_device.add_test_device(self.mockDevice1)
      test.mock_device.add_test_device(self.mockDevice2)
      test.mock_device.add_test_device(self.mockDevice3)
      self.timerReady = false
      test.timer.__create_and_queue_generic_timer(function () return self.timerReady end, 'oneshot')
      test.timer.__create_and_queue_test_time_advance_timer(CheckInterval, 'interval')
    end)

    test.register_coroutine_test('device test', function ()
      self.timerReady = true
      test.socket.capability:__set_channel_ordering('relaxed')
      test.socket.capability:__expect_send(self.mockDevice1:generate_test_message("main", present))
      test.socket.capability:__expect_send(self.mockDevice2:generate_test_message("main", present))
      test.socket.capability:__expect_send(self.mockDevice3:generate_test_message("main", not_present))
      test.wait_for_events()
      mockRouterResponse = [[
        {
        var TableTagValueList = '4|1|192.168.0.24|c8:b8:2f:86:a5:21|eero|1|192.168.0.35|7c:72:e4:90:26:08|--|1|192.168.0.42|00:14:ee:03:66:b7|MyCloud-XEC16K|1|192.168.0.108<br>2601:19b:c401:59b0:478b:7f77:e8f7:99d9|5c:96:66:dc:88:68|--|';
        var TableTagValueList = '9|DSHc|1|192.168.0.34|0c:1c:57:a9:01:0b|Ring-a9010b|DSHc|1|192.168.0.38|30:45:11:44:80:31|Ring-448031|DSHc|1|192.168.0.39|f0:45:da:3c:cd:37|Ring-3ccd37|DSHc|1|192.168.0.33|34:20:03:57:2f:9c||DSHc|1|192.168.0.23|34:20:03:57:18:e1||DSHc|1|192.168.0.29|34:20:03:2d:d5:74||DSHc|1|192.168.0.17|00:04:20:ef:e0:2f|HarmonyHub|DSHc|1|192.168.0.28|ac:ae:19:ba:00:8f|Basement|DSHc|1|192.168.0.9|00:80:92:8c:df:d1|BRW0080928CDFD1|';
        var TableTagValueList = '12|DSHc-5G|1|192.168.0.14<br>2601:19b:c401:59b0:f155:cd68:8c62:457|6a:2a:ef:27:d1:05|SM-R860|DSHc-5G|1|192.168.0.32<br>2601:19b:c401:59b0:f136:51d6:8264:a678|00:01:02:f5:72:fa|iphone|DSHc-5G|1|192.168.0.12<br>2601:19b:c401:59b0:dd4f:a49:e0a7:baf0|52:20:fc:0c:df:53||DSHc-5G|1|192.168.0.16|18:b4:30:bb:bc:90|09AA01AC53160FAW|DSHc-5G|1|192.168.0.36<br>2601:19b:c401:59b0:8194:a77c:2a38:a149|28:6d:97:70:0c:79|hubv3-3011000927|DSHc-5G|1|192.168.0.31<br>2601:19b:c401:59b0:d388:26d6:8a1b:2572|e4:fd:45:d3:22:e1|LAPTOP-VF7ADLII|DSHc-5G|1|192.168.0.19<br>2601:19b:c401:59b0:cc61:8ae4:1468:5f4b|d4:63:c6:62:8b:23|android-5ba69c37733ed8e8|DSHc-5G|1|192.168.0.25|e0:4f:43:a4:2a:35|RingPro-35|DSHc-5G|1|192.168.0.54|18:b4:30:cf:2c:13|09AA01RC321700CN|DSHc-5G|1|192.168.0.20|18:b4:30:bb:65:c3|09AA01AC52160U70|DSHc-5G|1|192.168.0.11<br>2601:19b:c401:59b0:c2ee:40ff:fe8e:11f0|c0:ee:40:8e:11:f0|MyArcticSpa0|DSHc-5G|1|192.168.0.98|10:59:32:71:bd:6c|TVRoomRoku|';
        }</html>
      ]]
      test.mock_time.advance_time(CheckInterval)
      test.socket.capability:__expect_send(self.mockDevice2:generate_test_message("main", not_present))
      test.socket.capability:__expect_send(self.mockDevice3:generate_test_message("main", present))
      test.wait_for_events()
      self.testSuccess = true
    end)

    test.run_registered_tests()
    lu.assertTrue(self.testSuccess)
  end
  function TestDriver:tearDown()
    mockRouterResponse = self.mockRouterResponse
    package.loaded['st.driver'] = nil
  end


os.exit(lu.LuaUnit.run('-v'))
