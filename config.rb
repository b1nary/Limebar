# IP API Url
# It expects a URL that returns a email without anything else
IP_API_URL = "http://icanhazip.com"

# TimeZoneDB API Key
# timezonedb.com - for timezone by location
TIMEZONEDB_API_KEY = 'YRGR35JML873'

# THEME
# Bar colors (ARGB!)
FONTS = ['mononoki', 'Droid Sans.10', 'FontAwesome-12']

# Clickable Areas
# only change this when you run out of areas
CLICKABLE_AREAS = 20

# Battery Indicator Symbols (font-awesome)
BATTERY_INDICATOR = ["\uf244","\uf243","\uf242","\uf241","\uf240"]
# Used by RAM, CPU, Network, ...
LOAD_INDICATOR = ["","▁","▂","▃","▄","▅","▆","▇","█"]
VOLUME_INDICATOR = LOAD_INDICATOR.dup.map{|i| [i,i]}.flatten

# Main screen
SCREEN = 'LVDS1'

# Wifi interface
WIFI = 'wlp3s0'

# Define widgets
WIDGETS = [
  # left
  {
    widget: :openbox_workspace,
    align: :left,
    symbols: ["\uf0c8", "\uf096"],
    cache: 600,
  },
  {
    widget: :battery,
    align: :left,
    format: "$symbol $indicator $percentage",
    indicator: :battery,
    cache: 120,
  },
  {
    widget: :ram,
    align: :left,
    format: "$indicator $percentage",
    cache: 60,
  },

  # center
  {
    widget: :battery,
    align: :center,
    cache: 120
  },

  # right
  {
    widget: :tray,
    align: :right,
    widgets: [
      :volume,
      :brightness,
      {
        widget: :network,
        format: "$options $external_ip"
      }
    ]
  }
]
