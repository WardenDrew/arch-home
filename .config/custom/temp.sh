while true
do
  sensors=$(sensors);
  if [[ -z "$sensors" ]]; then
    echo "󱔱";
    sleep 5;
    continue;
  fi

  temp=$(echo "$sensors" | grep 'Package id 0:' | tr -s ' ' | cut -d' ' -f4 | cut -d'.' -f1 | tr -d '+');
  forecolor="red";
  if (( temp < 40 )); then
    forecolor="navy";
  elif (( temp < 45 )); then
    forecolor="steelblue";
  elif (( temp < 50 )); then
    forecolor="turquoise";
  elif (( temp < 55 )); then
    forecolor="springgreen";
  elif (( temp < 60 )); then
    forecolor="yellow";
  elif (( temp < 65 )); then
    forecolor="orange";
  elif (( temp < 70 )); then
    forecolor="crimson";
  fi

  echo "<fc=${forecolor}><fn=1>󰏈</fn> <fn=1>${temp}</fn>󰔄</fc>";
  sleep 15;
done
