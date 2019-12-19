local awful = require( "awful" )
local wibox = require( "wibox" )
local beautiful = require( "beautiful" )
local freedesktop = require( "freedesktop" )

local capi = {
    awesome = awesome
  , screen = screen
  , client = client
}

local sup = "Mod4"

local layouts = nil
local tags = nil
local menu = nil
local launcher = nil
local api = {}

local left_layout = wibox.layout.fixed.horizontal()
local right_layout = wibox.layout.fixed.horizontal()
local center_layout = wibox.layout.fixed.horizontal()

function api:get_layouts()
  return layouts
end

function api:set_layouts( arg_layouts )
  if arg_layouts then
    layouts = arg_layouts
  else
    layouts = { awful.layout.suit.floating,
       awful.layout.suit.tile,
       awful.layout.suit.tile.left,
       awful.layout.suit.tile.bottom,
       awful.layout.suit.tile.top,
       awful.layout.suit.fair,
       awful.layout.suit.fair.horizontal,
       awful.layout.suit.spiral,
       awful.layout.suit.spiral.dwindle,
       awful.layout.suit.max,
       awful.layout.suit.max.fullscreen,
       awful.layout.suit.magnifier,
       awful.layout.suit.corner.nw,
       awful.layout.suit.corner.ne,
       awful.layout.suit.corner.sw,
       awful.layout.suit.corner.se,
     }
  end
  tags = {}
  for s = 1 , capi.screen.count() do
    tags[ s ] = awful.tag( { 1 } , s , layouts[1])
  end
end

-- launcher
function api:get_menu()
  return menu
end

function api:set_menu( powermanagement )
  local menu_after = { { "Awesome Restart", capi.awesome.restart , beautiful.awesome_icon } }

  if powermanagement then
    table.insert( menu_after, { "PowerManagement" , {
        { "Suspend"      , "sudo systemctl suspend"          }
      , { "Hibanete"     , "sudo systemctl hibernate"        }
      , { "Restart"      , "sudo systemctl reboot --force"   }
      , { "Shutdown"     , "sudo systemctl poweroff --force" }
    } } )
  end

  menu = freedesktop.menu.build( { after =  menu_after } )
end

function api:get_launcher()
  return launcher
end

function api:set_launcher()
  launcher = awful.widget.launcher( { image = beautiful.awesome_icon , menu = menu } )
  launcher:buttons( awful.util.table.join(
    awful.button( { } , 1 , function() menu:show( { keygrabber = true } ) end )
  ))
end

local function add_layout( layout, item, a, b, c, d )
  layout:add( wibox.container.margin( item, a, b, c, d) )
  return layout
end

function api:add_left_layout( item )
  left_layout = add_layout( left_layout, item, 0, 8, 0, 0 )
end

function api:add_center_layout( item )
  center_layout = add_layout( center_layout, item, 0, 8, 0, 0  )
end

function api:add_right_layout( item )
  right_layout = add_layout( right_layout, item, 8, 0, 0, 0  )
end

function api:set_wibar( wibar_height )
  awful.screen.connect_for_each_screen( function( s )
    s.wibar = awful.wibar( { position = "top", height = wibar_height  , screen = s } )
    s.promptbox = awful.widget.prompt()

    right_layout:insert( 1 , s.promptbox )
    right_layout:insert( 1 , wibox.widget.systray() )

    local wrapper = wibox.widget{
      layout = wibox.layout.align.horizontal,
      left_layout,
      center_layout,
      right_layout,
    }

    s.wibar:set_widget( wrapper )
  end)
end
return api
