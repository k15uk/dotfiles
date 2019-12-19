local api     = require( "rc/api" )
local rules   = require( "rc/rules" )
local keybind = require( "rc/keybind" )
require( "awful.autofocus" ) --autofocus
require( "rc/errors" )

require( "beautiful" ).init( os.getenv( "HOME" ) .. "/.config/awesome/theme.lua" )
api:set_layouts( { require( "awful" ).layout.suit.tile } )

rules:set_float_class( {
  "Gimp-2.8" ,
  "Pavucontrol" ,
  "Pcmanfm" ,
  "vlc" ,
  "keepassxc" ,
  "xpad" ,
  "Gnome-system-monitor" ,
  "Blueberry.py",
} )

rules:set_float_role ( {
  "bubble" ,
  "pop-up" ,
  "gimp-image-window"
} )

rules:set_float_name ( {
  "Appointment" ,
  "Java" ,
  "Event Tester" ,
  "Emulator" ,
} )

rules:set_float_type ( {
  "dialog" ,
} )

api:set_menu( true )
api:set_launcher()

keybind:set_keybind( "NeovimGtk" , "GTK_THEME=nvim nvim-gtk" )
rules:set_opacity( { { class = 'NeovimGtk', focus_opacity = 0.85 , normal_opacity = 0.75 } } )

rules:set_rules()

local awesompd = require( 'awesompd/awesompd' )

local mpdinstance = awesompd:create()
mpdinstance.font = "Cica"
mpdinstance.servers = { { server = '127.0.0.1' , port = '6600' } }
mpdinstance:register_buttons({ { "", awesompd.MOUSE_LEFT, mpdinstance:command_playpause() },
                               { "", awesompd.MOUSE_SCROLL_UP, mpdinstance:command_next_track() },
                               { "", awesompd.MOUSE_SCROLL_DOWN, mpdinstance:command_prev_track() },
                               { "", awesompd.MOUSE_RIGHT, mpdinstance:command_show_menu() }
                            })
mpdinstance:run()

api:add_left_layout( api.get_launcher() )
local pm = require( "pm2_5" )
if pm ~= nil then api:add_left_layout( pm:create( nil ) ) end
api:add_left_layout( mpdinstance.widget )

local launcher = require( 'launcher' )
launcher:set_vertical_margin( 5 )

local tag_groups = {
  "Gimp" , "Sk1" , "Inkscape" , "Gthumb" , "XnViewMP",
  "jetbrains-idea-ce" , "Mysql-workbench-bin" , "Gitg",
  "Ario", "Rhythmbox" , "Easytag"  ,
  "Evolution" ,
  "Skype"  ,
  "LibreOffice",
}
launcher:set_tag_groups( tag_groups )

api:add_center_layout(
  launcher:create( {
    { 'Chromium'           , 'chromium'                , '/usr/share/icons/Windows10/48x48/apps/chromium-browser.png'   , false } ,
    { 'NeovimGtk'          , 'GTK_THEME=nvim nvim-gtk' , '/usr/share/icons/hicolor/48x48/apps/org.daa.NeovimGtk.png'    , true  } ,
    { 'Pcmanfm'            , 'pcmanfm'                 , '/usr/share/icons/Windows10/48x48/apps/system-file-manager.png', true  } ,
    { 'Gitg'               , 'gitg'                    , '/usr/share/icons/hicolor/48x48/apps/org.gnome.gitg.png'       , false } ,
    { 'Mysql-workbench-bin', 'mysql-workbench'         , '/usr/share/icons/hicolor/48x48/apps/mysql-workbench.png'      , false } ,
    { 'xpad'               , 'xpad'                    , '/usr/share/icons/hicolor/scalable/apps/xpad.svg'              , false } ,
    { 'Gimp'               , 'gimp'                    , '/usr/share/icons/hicolor/48x48/apps/gimp.png'                 , false } ,
    { 'Inkscape'           , 'inkscape'                , '/usr/share/icons/hicolor/48x48/apps/inkscape.png'             , false } ,
    { 'keepassxc'          , 'keepassxc'               , '/usr/share/icons/hicolor/64x64/apps/keepassxc.png'            , false } ,
    { 'LibreOffice'        , 'libreoffice'             , '/usr/share/icons/Windows10/48x48/apps/libreoffice-main.png'   , false } ,
    { 'Evolution'          , 'evolution'               , '/usr/share/icons/Windows10/48x48/apps/evolution.png'          , false } ,
    { 'Ario'               , 'ario'                    , '/usr/share/icons/Windows10/48x48/apps/rhythmbox.png'          , false } ,
  } )
)

local apw = require("apw/widget")
local brightness = require( "brightness" )
local widget  = require( "widget" )

apw.SetMixer( "pavucontrol" )

local datewidget = widget:date( " %m/%d %a %H:%M:%S " , 1 , "Asia/Tokyo" )
local calendar = require( "calendar" )
if calendar ~= nil then calendar.set( datewidget ) end

local f = io.popen ("/bin/hostname")

local hostname = f:read("*a") or ""
f:close()
hostname =string.gsub(hostname, "\n$", "")

api:add_right_layout( apw )

if hostname == 'tablet' then
  api:add_right_layout( widget:battery( "Battery" , 60 ) )
end

if hostname == 'cocco' then
  api:add_right_layout( brightness:create( 'HDMI-0' , 10 ) )
  api:add_right_layout( widget:wifi( 'wlan0' , 'WIFI' , 1 ) )
end

api:add_right_layout( widget:cpu( "CPU" , 1 ) )

if hostname == 'cocco' then
  api:add_right_layout( widget:cputemp( 1 ) )
  api:add_right_layout( widget:ram( "RAM" , 1 ) )
  api:add_right_layout( widget:swap( "SWAP" , 1 ) )
end

api:add_right_layout( datewidget )

brightness:timer({
  '-0.01', -- 01:00
  '-0.01', -- 02:00
  '-0.01', -- 03:00
  '0'    , -- 04:00
  '0.01' , -- 05:00
  '0.01' , -- 06:00
  '0.01' , -- 07:00
  '0.01' , -- 08:00
  '0.01' , -- 09:00
  '0.01' , -- 10:00
  '0.01' , -- 11:00
  '0.01' , -- 12:00
  '0.01' , -- 13:00
  '0'    , -- 14:00
  '0'    , -- 15:00
  '0'    , -- 16:00
  '0'    , -- 17:00
  '0'    , -- 18:00
  '-0.01', -- 19:00
  '-0.01', -- 20:00
  '-0.01', -- 21:00
  '-0.01', -- 22:00
  '-0.01', -- 23:00
  '-0.01', -- 24:00
})

api:set_wibar( 22 )

--require( "wallpaper" ):create( 3600 , os.getenv('HOME').."/images/wallpaper" )
require( "wallpaper" ):set( os.getenv('HOME').."/images/wallpaper/DSC_0613.JPG" )
