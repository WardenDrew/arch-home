notify1='/run/xmobar-sound.reload';
notify2="$HOME/.local/state/wireplumber/default-routes";
wireplumber_output_id='@DEFAULT_SINK@';
wireplumber_input_id='@DEFAULT_SOURCE@';

function printSound {
  output_raw=$(wpctl get-volume "$wireplumber_output_id");
  input_raw=$(wpctl get-volume "$wireplumber_input_id");

  output_volume=$(echo "$output_raw" | cut -d' ' -f2);
  output_volume_pretty=$(echo "$output_volume" | sed 's/^0\.00/  0/' | sed 's/^0\.0/  /' | sed 's/^0\./ /' | sed 's/^1\./1/');
  output_muted=$(echo "$output_raw" | grep 'MUTED');
  output_symbol="<fc=green>󰕾</fc>";
  if [[ -n "$output_muted" ]]; then
    output_symbol="<fc=red>󰖁</fc>";
  fi
  
  #input_volume=$(echo "$input_raw" | cut -d' ' -f2);
  input_muted=$(echo "$input_raw" | grep 'MUTED');
  input_symbol="<fc=green>󰍬</fc>";
  micmute_state='0';
  if [[ -n "$input_muted" ]]; then
    input_symbol="<fc=red>󰍭</fc>";
    micmute_state='1';
  fi
  # We do this here so we dont have to query the user's wireplumber as root in our ACPI handler
  echo "$micmute_state" > '/sys/class/leds/platform::micmute/brightness';

  result="<fc=magenta><fn=1>${output_volume_pretty}</fn>%</fc>\
 <fn=1>${output_symbol}</fn>\
 <fn=1>${input_symbol}</fn>";
  echo "$result";
}

printSound;

while true; do
  while inotifywait -qq \
    -e modify \
    -e delete_self \
    -e attrib \
    "$notify1" "$notify2" 2>/dev/null; do
    printSound;
  done
  # inotify failed!
  sleep 1;
  printSound;
done
