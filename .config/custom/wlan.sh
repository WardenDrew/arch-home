while true
do
  wlan=$(nmcli -t -f active,ssid,signal dev wifi | grep -e '^yes:');
  if [[ -z "$wlan" ]]; then
    echo "󰤮";
    sleep 5;
    continue;
  fi

  ssid=$(echo "$wlan" | cut -d: -f2 | cut -c 1-16);
  signal=$(echo "$wlan" | cut -d: -f3);
  ip=$(ip -4 --brief -o addr show wlp0s20f3 | awk '{print $3}');
  ipaddr=$(echo "$ip" | cut -d/ -f1);
  ipcidr=$(echo "$ip" | cut -d/ -f2);
  if [[ "$ipcidr" != '24' ]]; then
    ipcidr="<fc=red>/<fn=1>${ipcidr}</fn></fc>";
  else
    ipcidr="/${ipcidr}";
  fi

  echo "<fc=green><fn=1>󰖩</fn> ${ssid}</fc> [<fc=cyan>${signal}</fc>%] <fc=orange>${ipaddr}</fc>${ipcidr}";
  sleep 5;
done
