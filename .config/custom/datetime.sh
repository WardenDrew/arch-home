while true
do
  datelocal=$(TZ=America/Los_Angeles date '+%Y-%b-%d');
  timelocal=$(TZ=America/Los_Angeles date '+%H%M');
  timeutc=$(TZ=UTC date '+%H%M');
  echo "<fc=limegreen>${datelocal}</fc> @ <fc=orange>${timelocal}</fc> PT [<fc=cyan>${timeutc}</fc>z]";
  sleep 1;
done
