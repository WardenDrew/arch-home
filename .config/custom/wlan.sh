while true
do
  wlan=$(nmcli -t -f active,ssid,signal dev wifi | grep -e '^yes:');
  if [[ -z "$wlan" ]]; then
    echo "󰤮";
    sleep 5;
    continue;
  fi

  ssid=$(echo "$wlan" | cut -d: -f2);
  signal=$(echo "$wlan" | cut -d: -f3);
  ip=$(ip -4 --brief -o addr show wlp0s20f3 | awk '{print $3}');
  ipaddr=$(echo "$ip" | cut -d/ -f1);
  ipcidr=$(echo "$ip" | cut -d/ -f2);
  echo "<fn=1>󰖩</fn> <fc=green>${ssid}</fc> <fc=orange>${signal}</fc>% <fc=royalblue>${ipaddr}</fc>/<fc=red>${ipcidr}</fc>";
  sleep 5;
done
