# Waybar Weather Module

Simple weather script for Waybar that shows current conditions and a 3-day forecast using wttr.in.

## What it looks like

**Bar:** ☁️ 8°C

**Tooltip:**
```
Leiden
━━━━━━━━━━━━━━━━━━━━━━
Now: Overcast
Temp: 8°C | Feels: 5°C
Wind: ↑22km/h | Rain: 0.0mm
Humidity: 93% | Pressure: 1016hPa

━━━━━━━━━━━━━━━━━━━━━━
Monday     ☁️   8°C
Tuesday    ☁️   8°C
Wednesday  ☁️   8°C
```

## Requirements

- `curl`
- `jq`
- `bash`

```bash
# Arch
sudo pacman -S curl jq

# Debian/Ubuntu
sudo apt install curl jq
```

## Setup

Copy the script:
```bash
mkdir -p ~/.config/waybar/scripts
cp weather.sh ~/.config/waybar/scripts/
chmod +x ~/.config/waybar/scripts/weather.sh
```

Add to your waybar config (`~/.config/waybar/config.jsonc`):
```jsonc
{
  "modules-right": [
    "custom/weather",
    // other modules...
  ],

  "custom/weather": {
    "exec": "~/.config/waybar/scripts/weather.sh",
    "interval": 600,
    "return-type": "json",
    "tooltip": true
  }
}
```

Optional styling in `~/.config/waybar/style.css`:
```css
#custom-weather {
  margin: 0 7.5px;
}
```

Reload waybar:
```bash
pkill waybar; waybar &
```

## Configuration

Edit the top of `weather.sh`:

```bash
# Set your city (or leave empty for IP-based detection)
CITY="Leiden"

# Language code
LANG="en"

# Customize tooltip labels
LABEL_NOW="Now"
LABEL_TEMP="Temp"
LABEL_FEELS="Feels"
# etc...
```

### Supported languages

The wttr.in API supports tons of languages. Just change `LANG` to one of these:

`en`, `ko`, `ja`, `zh`, `de`, `fr`, `es`, `ru`, `it`, `pt`, and [many more](https://github.com/chubin/wttr.in#supported-languages).

If you change the language, you'll probably want to update the labels too. For example, for Korean:
```bash
LANG="ko"
LABEL_NOW="현재"
LABEL_TEMP="온도"
LABEL_FEELS="체감"
LABEL_WIND="바람"
LABEL_RAIN="강수"
LABEL_HUMIDITY="습도"
LABEL_PRESSURE="기압"
```

### Other location options

```bash
CITY=""                    # Auto-detect from IP
CITY="Tokyo"               # City name
CITY="~Eiffel+Tower"       # By landmark
CITY="@48.8584,2.2945"     # By coordinates
```

### Update interval

Change `interval` in your waybar config:
```jsonc
"interval": 600,   // 10 minutes
"interval": 1800,  // 30 minutes
"interval": 3600,  // 1 hour
```

## Troubleshooting

**Script not working?**

Test it manually:
```bash
~/.config/waybar/scripts/weather.sh
```

Check if you can reach wttr.in:
```bash
curl wttr.in/London?format=%c%t
```

Make sure the script is executable:
```bash
chmod +x ~/.config/waybar/scripts/weather.sh
```

**Wrong location?**

Try being more specific or use coordinates.

**jq not found?**

Install it (see Requirements above).

## Credits

Weather data from [wttr.in](https://github.com/chubin/wttr.in)

## License

Do whatever you want with it.
