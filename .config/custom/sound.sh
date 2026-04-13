asound_state_file='/var/lib/alsa/asound.state';

function printSound {
  master_raw=$(amixer get Master | grep "Mono: Playback");
  capture_raw=$(amixer get Capture | grep "Front Left: Capture");
  master_state=$(echo "$master_raw" | awk '{print $6}');
  master_volume=$(echo "$master_raw" | awk '{print $5}' | tr -d '[]' | cut -d. -f1);
  capture_state=$(echo "$capture_raw" | awk '{print $7}');

  if [[ "$capture_state" == "[on]" ]]; then
    capture_output="<fc=green>󰍬</fc>";
  else
    capture_output="<fc=red>󰍭</fc>";
  fi

  if [[ "$master_state" == "[on]" ]]; then
    mute_output="<fc=green>󰕾</fc>";
  else
    mute_output="<fc=red>󰖁</fc>";
  fi

  echo "<fn=1>${capture_output}</fn> <fn=1>${mute_output}</fn> <fc=magenta><fn=1>${master_volume}</fn>dB</fc>";
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
