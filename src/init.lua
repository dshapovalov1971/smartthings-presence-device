local Driver = require 'st.driver'
local caps = require 'st.capabilities'
local router = require 'router'
require '../env'

local d = Driver('Network Presence Driver', {
  discovery = function (driver, _, should_continue)
    local devices, t = {}, nil
    for _, device in pairs(driver:get_devices()) do
      devices[device.device_network_id] = true
    end

    local d = function ()
      if should_continue() then
        for id, name in pairs(router.connected_devices()) do
          if not devices[id] then
            assert(
              driver:try_create_device({
                type = 'LAN',
                device_network_id = id,
                label = name,
                profile = 'network.presence'}),
              'failed to send try_create_device'
            )
            devices[id] = true
          end
        end
      else
        driver:cancel_timer(t)
      end
    end
    t = driver:call_on_schedule(5, d)
    d()
  end,
})

d:call_on_schedule(CheckInterval, function ()
  local devices, present, not_present = {}, caps.presenceSensor.presence.present(), caps.presenceSensor.presence.not_present()
  for _, device in pairs(d:get_devices()) do
    devices[device.device_network_id] = { device = device, new_state = not_present }
  end

  for id in pairs(router.connected_devices()) do
    if devices[id] then
      devices[id].new_state = present
    end
  end

  for _, v in pairs(devices) do
    if v.device.get_latest_state('main', 'presenceSensor', 'presence').value ~= v.new_state.value.value then
      v.device.emit_event(v.new_state)
    end
  end
end)

d:run()
