local Driver = require "st.driver"

local d = Driver("Network Presence Driver", {
  discovery = function (driver, _, should_continue)
  end,
})

d:run()
