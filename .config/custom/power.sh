#!/bin/bash

# Thought about subscribing to upower monitor detail here
# But it gives very frequent updates while connected to
# the charger

upower_device="/org/freedesktop/UPower/devices/battery_BAT0";

function printPower {
  while read line; do
    key=$(echo "$line" | cut -d':' -f1 | tr -d ' ');
    value=$(echo "$line" | cut -d':' -f2 | tr -d ' ');
    case $key in
      state)
        state="$value";
        ;;
      energy)
        energy=$(echo "$value" | cut -d 'W' -f1);
        ;;
      energy-full)
        energy_full=$(echo "$value" | cut -d 'W' -f1);
        ;;
      energy-rate)
        energy_rate=$(echo "$value" | cut -d 'W' -f1);
        energy_rate_watts=$(echo "$energy_rate" | cut -d '.' -f1);
        energy_rate_tenths=$(echo "$energy_rate" | cut -d '.' -f2 | cut -c 1);
        if [[ -n "$energy_rate_tenths" && $energy_rate_tenths -ge 5 ]]; then
          energy_rate_watts=$(( energy_rate_watts + 1 ));
        fi
        ;;
      percentage)
        percentage=$(echo "$value" | cut -d '%' -f1);
        ;;
      *)
        ;;
    esac
  done < <(upower -i "$upower_device")

  if [[ "$state" == 'discharging' ]]; then
    direction="<fc=red>-";
    forecolor="red";
    icon="󱃍";
    if (( percentage > 99 )); then
      forecolor="green";
      icon="󰁹";
    elif (( percentage > 90 )); then
      forecolor="limegreen";
      icon="󰂂";
    elif (( percentage > 80 )); then
      forecolor="limegreen";
      icon="󰂁";
    elif (( percentage > 70 )); then
      forecolor="limegreen";
      icon="󰂀";
    elif (( percentage > 60 )); then
      forecolor="orange";
      icon="󰁿";
    elif (( percentage > 50 )); then
      forecolor="orange";
      icon="󰁾";
    elif (( percentage > 40 )); then
      forecolor="orange";
      icon="󰁽";
    elif (( percentage > 30 )); then
      icon="󰁼";
    elif (( percentage > 20 )); then
      icon="󰁻";
    elif (( percentage > 10 )); then
      icon="󰁺";
    fi
  else
    direction="<fc=slateblue>+";
    forecolor="slateblue";
    icon="󰢟";
    if (( percentage > 99 )); then
      forecolor="green";
      icon="󰂄";
    elif (( percentage > 90 )); then
      icon="󰂋";
    elif (( percentage > 80 )); then
      icon="󰂊";
    elif (( percentage > 70 )); then
      icon="󰢞";
    elif (( percentage > 60 )); then
      icon="󰂉";
    elif (( percentage > 50 )); then
      icon="󰢝";
    elif (( percentage > 40 )); then
      icon="󰂈";
    elif (( percentage > 30 )); then
      icon="󰂇";
    elif (( percentage > 20 )); then
      icon="󰂆";
    elif (( percentage > 10 )); then
      icon="󰢜";
    fi
  fi

  echo "<fn=1>󱐋${direction}${energy_rate_watts}</fc></fn>W | <fc=${forecolor}>${energy} /${energy_full}Wh <fn=1>${percentage}% ${icon}</fn></fc>";
  sleep 15;
}

while true; do
  printPower;
done
