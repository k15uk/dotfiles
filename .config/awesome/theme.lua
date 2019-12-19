-- Main
theme = dofile (  '/usr/share/awesome/themes/gtk/theme.lua' )
themes_path = '/usr/share/awesome/themes/default/'

-- Wallpaper
theme.wallpaper = os.getenv('HOME').."/.config/awesome/wallpaper.png"

-- Styles
theme.font = 'Cica 11'

-- border
theme.border_width  = 6
theme.border_focus  = theme.border_focus
theme.border_normal = theme.border_normal

-- tasklist
theme.tasklist_bg_focus = theme.bg_focus

-- Menu
theme.menu_height = '24'
theme.menu_width = theme.menu_height * 12
theme.menu_border_width = 0

-- tag
theme.master_width_factor = 0.42
theme.column_count = 2

-- gap
theme.useless_gap = 0

-- pulse audio
theme.apw_fg_color      = theme.bg_focus
theme.apw_bg_color      = theme.bg_minimize
theme.apw_mute_fg_color = theme.bg_urgent
theme.apw_mute_bg_color = theme.bg_minimize
theme.apw_show_text     = true
theme.apw_text_colot    = theme.fg_focus

return theme
