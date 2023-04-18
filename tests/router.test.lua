local test = require 'integration_test'
local cosock = require "cosock"
local http = cosock.asyncify "socket.http"
local ltn12 = require 'ltn12'
local utils = require "st.utils"
local router = require('../src/router')

http.request = function(p)
  if type(p) == 'string' then
    return 1, 200, {['set-cookie'] = 'cookie'}
  else
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

assert(utils.stringify_table(router.connected_devices(), '', true) == utils.stringify_table({
  ['00:04:20:ef:e0:2f']="HarmonyHub",
  ['00:14:ee:03:66:b7']="MyCloud-XEC16K",
  ['00:80:92:8c:df:d1']="BRW0080928CDFD1",
  ['0c:1c:57:a9:01:0b']="Ring-a9010b",
  ['10:59:32:71:bd:6c']="TVRoomRoku",
  ['18:b4:30:bb:65:c3']="09AA01AC52160U70",
  ['18:b4:30:bb:bc:90']="09AA01AC53160FAW",
  ['18:b4:30:cf:2c:13']="09AA01RC321700CN",
  ['28:6d:97:70:0c:79']="hubv3-3011000927",
  ['30:45:11:44:80:31']="Ring-448031",
  ['34:20:03:2d:d5:74']="",
  ['34:20:03:57:18:e1']="",
  ['34:20:03:57:2f:9c']="",
  ['52:20:fc:0c:df:53']="",
  ['5c:96:66:dc:88:68']="--",
  ['62:78:a5:f5:72:fa']="DSH",
  ['6a:2a:ef:27:d1:05']="SM-R860",
  ['7c:72:e4:90:26:08']="--",
  ['ac:ae:19:ba:00:8f']="Basement",
  ['c0:ee:40:8e:11:f0']="MyArcticSpa0",
  ['c8:b8:2f:86:a5:21']="eero",
  ['d4:63:c6:62:8b:23']="android-5ba69c37733ed8e8",
  ['e0:4f:43:a4:2a:35']="RingPro-35",
  ['e4:fd:45:d3:22:e1']="LAPTOP-VF7ADLII",
  ['f0:45:da:3c:cd:37']="Ring-3ccd37",
}, '', true));