local gears = require( "gears" )
local awful = require( "awful" )
local wibox = require( "wibox" )
local api   = require( "rc/api" )
local wallpaper = require( "wallpaper" )
local launcher = require( 'launcher' )

local capi = {
    awesome = awesome
  , root = root
  , mouse = mouse
  , screen = screen
  , client = client
}

local keybind = {}

local sup = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shift = "Shift"

local client_keys = nil
local client_buttons = nil

local terminal_class
local terminal_command
local terminal_add_command

function keybind:get_client_keys()
  return client_keys
end

function keybind:get_client_buttons()
  return client_buttons
end

local set_floating = function ( c )
  awful.client.floating.toggle()
  if ( c.titlebar_disable ) then
    return
  elseif ( awful.client.object.get_floating( c ) ) then
    awful.titlebar.show( c )
  else
    awful.titlebar.hide( c )
  end
end

local display_terminal = function ()
  local cl = nil
  local tag = awful.screen.focused().selected_tag
  for _, c in ipairs ( capi.client.get() ) do
    if ( c.class == terminal_class ) then
      cl = c
      break
    end
  end
  if ( cl == nil ) then
    awful.spawn.with_shell( terminal_command )
    return
  elseif ( cl:tags()[1] ~= tag ) then
    cl:move_to_tag( tag )
  elseif ( capi.client.focus ~= cl ) then
    capi.client.focus = cl
  else
    awful.spawn.with_shell( terminal_add_command )
  end
  cl.minimized = false
end

-- im toggle
local im_toggle = function ()
  awful.spawn.with_shell( '[ $( ibus engine ) = "xkb:us::eng" ] && ibus engine mozc-jp || ibus engine xkb:us::eng' )
end

-- Key binds
local bindkeys = function( altkey , key , press , release )
  capi.root.keys( gears.table.join( capi.root.keys() , awful.key( altkey , key , press , release ) ) )
end

local mg = capi.screen[ capi.mouse.screen ].geometry
-- mouse move
local mouse_move = function( x , y )
  local mx = capi.mouse.coords().x + x
  local my =  capi.mouse.coords().y + y
  if mx < 0 then
    mx = mg.width
  elseif mx > mg.width then
    mx = 0
  end

  if my < 0 then
    my = mg.height
  elseif my > mg.height then
    my = 0
  end
  capi.mouse.coords {
    x = mx ,
    y = my
  }
end

local set_mouse_emulate = function()
  local mouse_btn = {
    { alt, 'i', 1 } ,
    { alt, 'o', 2 } ,
    { alt, 'u', 3 } ,
    { sup, 'h', 6 } ,
    { sup, 'j', 5 } ,
    { sup, 'k', 4 } ,
    { sup, 'l', 7 } ,
  }

  for _, btn in pairs( mouse_btn ) do
    bindkeys( { btn[1] } , btn[2] , function ()
      awful.spawn.with_shell( "xdotool mousedown --clearmodifiers " .. btn[3] )
    end, function ()
      awful.spawn.with_shell( "xdotool mouseup   --clearmodifiers " .. btn[3] )
    end )
  end

  -- mouse emulate
  bindkeys( { alt         } , "h" , function () mouse_move( -16 ,  0 ) end )
  bindkeys( { alt , sup   } , "h" , function () mouse_move( -4  ,  0 ) end )
  bindkeys( { alt , shift } , "h" , function () mouse_move( -1  ,  0 ) end )
  bindkeys( { alt         } , "j" , function () mouse_move(  0 ,  16 ) end )
  bindkeys( { alt , sup   } , "j" , function () mouse_move(  0 ,   4 ) end )
  bindkeys( { alt , shift } , "j" , function () mouse_move(  0 ,   1 ) end )
  bindkeys( { alt         } , "k" , function () mouse_move(  0 , -16 ) end )
  bindkeys( { alt , sup   } , "k" , function () mouse_move(  0 ,  -4 ) end )
  bindkeys( { alt , shift } , "k" , function () mouse_move(  0 ,  -1 ) end )
  bindkeys( { alt         } , "l" , function () mouse_move(  16 ,  0 ) end )
  bindkeys( { alt , sup   } , "l" , function () mouse_move(   4 ,  0 ) end )
  bindkeys( { alt , shift } , "l" , function () mouse_move(   1 ,  0 ) end )
end

local set_key_remap = function()
  local remap_keys = {
    { ctrl, 'h', 'Left'      } ,
    { ctrl, 'j', 'Down'      } ,
    { ctrl, 'k', 'Up'        } ,
    { ctrl, 'l', 'Right'     } ,
    { ctrl, 'm', 'Return'    } ,
    { ctrl, 'n', 'BackSpace' } ,
  }

  for _, btn in pairs( remap_keys ) do
    bindkeys( { btn[1] } , btn[2] , function()
      capi.root.fake_input( 'key_release' , btn[2] )
      awful.spawn.with_shell( "xdotool key --clearmodifiers " .. btn[3] )
    end )
  end
end

local set_global_key = function ()
  -- window management
  bindkeys( { alt        } , "=" , function () awful.client.incwfact(  0.5  ) end )
  bindkeys( { alt        } , "-" , function () awful.client.incwfact( -0.5  ) end )
  bindkeys( { alt , ctrl } , "=" , function () awful.client.incwfact(  0.05 ) end )
  bindkeys( { alt , ctrl } , "-" , function () awful.client.incwfact( -0.05 ) end )

  bindkeys( { sup        } , "=" , function () awful.tag.incmwfact(  0.1  ) end )
  bindkeys( { sup        } , "-" , function () awful.tag.incmwfact( -0.1  ) end )
  bindkeys( { sup , ctrl } , "=" , function () awful.tag.incmwfact(  0.01 ) end )
  bindkeys( { sup , ctrl } , "-" , function () awful.tag.incmwfact( -0.01 ) end )

  bindkeys( { sup } , "Right" , function () awful.client.swap.byidx(  1 ) end )
  bindkeys( { sup } , "Left"  , function () awful.client.swap.byidx( -1 ) end )

  -- tag change
  bindkeys( { sup , shift , ctrl } , "Tab" , function () awful.tag.viewprev() end )
  bindkeys( { sup , shift        } , "Tab" , function () awful.tag.viewnext() end )

  -- window change
  bindkeys( { sup , ctrl } , "Tab" , function () awful.client.focus.byidx( -1 ) end )
  bindkeys( { sup        } , "Tab" , function () awful.client.focus.byidx(  1 ) end )

  -- awesome restart
  bindkeys( { sup , ctrl } , "r" , capi.awesome.restart )

  -- launcher
  bindkeys( { sup } , "a" , function () api:get_menu():toggle( { keygrabber = true } ) end )

-- wallpaper
  bindkeys( { ctrl , alt } , ',' , function() wallpaper:change( -1 ) end )
  bindkeys( { ctrl , alt } , '.' , function() wallpaper:change(  1 ) end )

  -- tag move
  bindkeys( { sup , shift } , "Escape" , function () launcher:tag_previous() end )
  bindkeys( { sup         } , "Escape" , function () launcher:tag_next() end )

  bindkeys( { alt , shift } , "Escape" , function () launcher:move_to_previous_tag() end )
  bindkeys( { alt         } , "Escape" , function () launcher:move_to_next_tag() end )

  bindkeys( { sup         } , "space"  , function () launcher:move_to_new_tag() end )

  -- ime
  bindkeys( { ctrl } , 'Shift_L' , function() im_toggle() end )
  bindkeys( { ctrl } , 'space'   , function() im_toggle() end )

  -- screenshot
  bindkeys( { sup } , "p" , function ()
    awful.spawn.with_shell( "maim -s ~/images/$(date +%s).png" )
  end )
  bindkeys( { sup , ctrl } , "p" , function ()
    awful.spawn.with_shell( "scrot -u -e 'mv $f ~/images/screenshots/'" )
  end )

  -- run prompt
  bindkeys( { sup } , "r"       , function ()
    awful.screen.focused().promptbox:run()
  end , { description = "run prompt" , group = "launcher" } )

  bindkeys( { sup } , "Return"  , function () display_terminal() end ) -- terminal

  -- launch/toggle application
  bindkeys( { sup } , "x"       , function () awful.client.restore():raise() end ) -- minimize window restore

  -- tab manaement
  for i = 1,9 do
    bindkeys( { sup } ,  "#" .. i + 9 ,
      function () launcher:tag_change( i ) end )
    bindkeys( { sup , shift } ,  "#" .. i + 9 ,
      function () launcher:launch( i ) end )
  end
end

local set_client_key = function ()
  -- window control
  client_keys = awful.util.table.join(
      awful.key( { sup } , "w" , function ( c ) c:kill() end )
    , awful.key( { sup } , "z" , function ( c ) c.minimized = true end )
    , awful.key( { sup } , "m" , function ( c ) c.maximized = not c.maximized end )
    , awful.key( { sup } , "t" , function ( c ) c.ontop = not c.ontop end )

    -- window floating toggle
    , awful.key( { sup } , "f" , function ( c ) set_floating( c ) end )
  )
  -- mouse event
  client_buttons = awful.util.table.join(
    awful.button( { } , 1 , function ( c )
      capi.client.focus = c; c:raise()
    end )
  )
end

function keybind:set_keybind( cls , cmd , add )
  terminal_class = cls
  terminal_command = cmd
  terminal_add_command = add
  set_global_key()
  set_client_key()
  set_mouse_emulate()
  set_key_remap()
end

return keybind
