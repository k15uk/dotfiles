local capi = { awesome = awesome }
local naughty = require("naughty") -- Notification library
-- エラー処理
if capi.awesome.startup_errors then
  naughty.notify( { preset = naughty.config.presets.critical ,
    title = "Oops, there were errors during startup!" ,
    text = capi.awesome.startup_errors } )
end
do
  local in_error = false
  capi.awesome.connect_signal( "debug::error" , function ()
  -- Make sure we don't go into an endless error loop
  if in_error then return end
  in_error = true
  end )
end

