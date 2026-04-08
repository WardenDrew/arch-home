while true
do
  sensors=$(sensors);
  if [[ -z "$sensors" ]]; then
    echo "󱔱";
    sleep 5;
    continue;
  fi

  package_temp=$(echo "$sensors" | grep 'Package id 0:' | tr -s ' ' | cut -d' ' -f4 | tr -d '+');
  echo "<fn=1>󰏈</fn> <fc=red>${package_temp}</fc>";
  sleep 5;
done
