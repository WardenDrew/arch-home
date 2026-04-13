while true
do
  workspace=$(xprop -root -notype _NET_CURRENT_DESKTOP | cut -d= -f2 | tr -d ' ');
  layout=$(xprop -root -notype _XMONAD_LOG | cut -d= -f2- | tr -d '"' | cut -d: -f2 | tr -d ' ');
  output_text="<fn=1>󱂬</fn> #$workspace $layout";

  window_ids=$(wmctrl -l | cut -f1 -d' ');
  num_minimized=$(echo "$window_ids" | xargs -I{} xprop -id {} WM_STATE | grep -c "window state: Iconic");
  if [[ "$num_minimized" -gt 0 ]]; then
    output_text="$output_text <fc=red><fn=1>󰈉</fn> <fn=1>${num_minimized}</fn></fc>";
  fi

  echo "$output_text";

  sleep 1;
done
