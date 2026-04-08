brightness_file='/sys/class/backlight/intel_backlight/brightness';
max_brightness_file='/sys/class/backlight/intel_backlight/max_brightness';

function printBrightness {
  brightness=$(cat "$brightness_file");
  max_brightness=$(cat "$max_brightness_file");
  if [[ -z "$brightness" || -z "$max_brightness" || $max_brightness -eq 0 ]]; then
    echo "󱓤";
    return;
  fi

  percentage=$(( 100 * brightness / max_brightness ));

  echo "<fn=1>󰖙</fn> <fc=slateblue>${percentage}</fc>%";
}

printBrightness;

while inotifywait -qq -e modify "$brightness_file"; do
  printBrightness;
done
