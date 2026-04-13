#!/bin/bash

# Set this to non empty to enable
# Logs all unknown ACPI events to journalctl
DEBUG_LOG=

# # # # # # # # # # # #
# # # ALSA SOUND  # # #
# # # # # # # # # # # #

saveAlsaState() {
  alsactl store;
  chmod 644 /var/lib/alsa/asound.state;
}

# # # # # # # # # # # # # # # #
# # # BRIGHTNESS CONROL # # # #
# # # # # # # # # # # # # # # #

MAX_BRIGHTNESS_DEV="/sys/class/backlight/intel_backlight/max_brightness";
CURRENT_BRIGHTNESS_DEV="/sys/class/backlight/intel_backlight/brightness";
# Through Experimentation 0 turns the display off
MIN_BRIGHTNESS=0;
BRIGHTNESS_STEP=1000;

adjustBrightness() {
  max_brightness=$(cat "$MAX_BRIGHTNESS_DEV");
  if [[ -z "$max_brightness" ]]; then
    logger "ERROR: Brightness FAILED: Could not determine max brightness!";
    exit -1;
  fi
  
  new_brightness=$(( $(cat "$CURRENT_BRIGHTNESS_DEV") + $1 ));
  if [[ -z "$new_brightness" ]]; then
    logger "ERROR: Brightness FAILED: Could not determine new brightness!";
    exit -1;
  fi

  if (( "$new_brightness" > "$max_brightness" )); then
    logger "WARN: Brightness is greater than max. Setting to max!";
    echo "$max_brightness" > "$CURRENT_BRIGHTNESS_DEV";
  elif (( "$new_brightness" < "$MIN_BRIGHTNESS" )); then
    logger "WARN: Brightness is less than min. Setting to min!";
    echo "$MIN_BRIGHTNESS" > "$CURRENT_BRIGHTNESS_DEV";
  else
    echo "$new_brightness" > "$CURRENT_BRIGHTNESS_DEV";
  fi

}

# # # # # # # # # # # # # # # # # #
# # # # ACPI EVENT HANDLERS # # # #
# # # # # # # # # # # # # # # # # #

# Power Button, Lid, and Sleep events are all handled by LogonD
# WLAN toggle button handled by NetworkManager

case "$1" in
  button/mute)
    logger "F1_MUTE";
    amixer set Master toggle;
    saveAlsaState;
    ;;
  button/volumedown)
    logger "F2_VOLUME_DOWN";
    amixer set Master 5%-;
    saveAlsaState;
    ;;
  button/volumeup)
    logger "F3_VOLUME_UP";
    amixer set Master unmute;
    amixer set Master 5%+;
    saveAlsaState;
    ;;
  button/micmute)
    logger "F4_MIC_MUTE";
    cap_state=$(amixer get Capture | grep "Front Left: Capture" | awk '{print $7}');
    if [[ "$cap_state" == "[on]" ]]; then
      amixer set Capture nocap;
      echo "1" > "/sys/class/leds/platform::micmute/brightness";
    else
      amixer set Capture cap;
      echo "0" > "/sys/class/leds/platform::micmute/brightness";
    fi
    saveAlsaState;
    ;;
  video/brightnessdown)
    logger "F5_BRIGHTNESS_DOWN";
    adjustBrightness "-$BRIGHTNESS_STEP";
    ;;
  video/brightnessup)
    logger "F6_BRIGHTNESS_UP";
    adjustBrightness "$BRIGHTNESS_STEP";
    ;;
  video/switchmode)
    logger "F7_VIDEO_SWITCH_MODE";
    ;;
  button/wlan)
    # Handled by Network Manager
    logger "F8_WLAN";
    ;;
  ibm/hotkey)
    case "$4" in
      00001317)
        logger "F9_MESSAGE";
        ;;
      00001318)
        logger "F10_PHONE";
        ;;
      00001319)
        logger "F11_HANGUP";
        ;;
      00001311)
        logger "F12_STAR";
        ;;
      00001312)
        logger "PRTSC_SNIPPING";
        ;;
    esac
    ;;
  *)
    if [[ -n "$DEBUG_LOG" ]]; then
      logger "ACPI: $1 / $2 / $3 / $4";
    fi
    ;;
esac
