local awful     = require( "awful" )
local gears     = require( "gears" )
local wibox     = require( "wibox" )
local beautiful = require( "beautiful" )
local api       = require( "rc/api" )
local keybind   = require( "rc/keybind" )
-- window rules
local capi = { client = client }

local rules = {}

local float_class = nil
local float_role  = nil
local float_name  = nil
local float_type  = nil

function rules:set_float_class( arg )
  float_class = arg
end

function rules:set_float_role ( arg )
  float_role = arg
end

function rules:set_float_name ( arg )
  float_name = arg
end

function rules:set_float_type ( arg )
  float_type = arg
end

function rules:set_opacity( classies )
  for _,cls in ipairs( classies ) do
    capi.client.connect_signal( "focus" , function( c )
      if c.class == cls['class'] then
        c.opacity = cls['focus_opacity']
      end
    end )

    capi.client.connect_signal( "unfocus" , function( c )
      if c.class == cls['class'] then
        c.opacity = cls['normal_opacity']
      end
    end )
  end
end

function rules:set_rules()
  awful.rules.rules = { {
    rule = { }
    , properties = {
        border_width = beautiful.border_width
      , border_color = beautiful.border_normal
      , focus = awful.client.focus.filter
      , raise = true
      , keys = keybind:get_client_keys() or nil
      , buttons = keybind:get_client_buttons() or nil
      , screen = awful.screen.preferred
      , placement = awful.placement.no_overlap+awful.placement.no_offscree
      , floating = false
      , titlebars_enabled = true
    } }
      -- Floating clients.
    , {
      rule_any = {
          instance = { }
        , class = float_class
        , role  = float_role
        , name  = float_name
        , type  = float_type
      }
      , properties = { floating = true } }

    -- Add titlebars to normal clients and dialogs
    , { rule_any = { type = { "normal" } }
      , properties = { titlebars_enabled = true } }
  }

  capi.client.connect_signal( "focus" , function( c )
    c.border_color = beautiful.border_focus
  end )

  capi.client.connect_signal( "unfocus" , function( c )
    c.border_color = beautiful.border_normal
  end )

  -- add a titlebar if titlebars_enabled is set to true in the rules.
  capi.client.connect_signal( "request::titlebars" , function( c )
    local buttons = gears.table.join(
      awful.button( { }, 1, function()
        capi.client.focus = c
        c:raise()
        awful.mouse.client.move(c)
      end),
      awful.button( { }, 3, function()
        capi.client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
      end)
    )
    awful.titlebar( c , { size = 32 } ) :setup {
        awful.titlebar.widget.iconwidget ( c )
      , {
            awful.titlebar.widget.titlewidget ( c )
          , buttons = buttons
          , layout = wibox.layout.flex.horizontal
        }
      , awful.titlebar.widget.closebutton ( c )
      , layout = wibox.layout.align.horizontal
    }
  end)

  -- Set floating window position and titlebar when creating
  capi.client.connect_signal( "manage" ,
    function( c )
      if ( c.titlebar_disable or c.floating == false ) then
        awful.titlebar.hide( c )
      elseif c.floating then
        awful.titlebar.show( c )
        local offset = 0
        for _, cl in ipairs ( capi.client.get() ) do
          if c.first_tag == cl.first_tag and cl.floating then
            offset = offset + 32
          end
        end
        c.x = offset
        c.y = offset
      end
    end)

  capi.client.connect_signal( "request::activate",
    function( c , context , hints )
      if c.minimized then
        c.minimized = false
      end
      awful.ewmh.activate( c , context , hints )
    end)
end
return rules
