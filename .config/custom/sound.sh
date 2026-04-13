asound_state_file='/var/lib/alsa/asound.state';

function printSound {
  master_raw=$(amixer get Master | grep "Mono: Playback");
  capture_raw=$(amixer get Capture | grep "Front Left: Capture");
  master_state=$(echo "$master_raw" | awk '{print $6}');
  master_volume=$(echo "$master_raw" | awk '{print $5}' | tr -d '[]' | cut -d. -f1);
  capture_state=$(echo "$capture_raw" | awk '{print $7}');

  if [[ "$capture_state" == "[on]" ]]; then
    capture_output="<fn=1><fc=green>󰍬</fc></fn>";
  else
    capture_output="<fn=1><fc=red>󰍭</fc></fn>";
  fi

  if [[ "$master_state" == "[on]" ]]; then
    mute_output="<fn=1><fc=green>󰕾</fc></fn>";
  else
    mute_output="<fn=1><fc=red>󰖁</fc></fn>";
  fi

  echo "${capture_output} ${mute_output} <fc=yellow>${master_volume}</fc>dB";
}

printSound;

while true; do
  while inotifywait -qq -e modify -e delete_self "$asound_state_file" 2>/dev/null; do
    printSound;
  done
  # Inotify failed to read the file likely race condition with permissions
  sleep 1;
  printSound;
done
