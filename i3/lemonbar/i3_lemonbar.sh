#! /bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar

. $(dirname $0)/i3_lemonbar_config

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
	printf "%s\n" "The status bar is already running." >&2
	exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

### EVENTS METERS

# Window title, "WIN"
xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${panel_fifo}" &

# i3 Workspaces, "WSP"
# TODO : Restarting I3 breaks the IPC socket con. :(
$(dirname $0)/i3_workspaces.pl > "${panel_fifo}" &

# IRC, "IRC"
# only for init
#~/bin/irc_warn &

# Conky, "SYS"
conky -c $(dirname $0)/i3_lemonbar_conky > "${panel_fifo}" &

### UPDATE INTERVAL METERS
cnt_vol=${upd_vol}
cnt_mail=${upd_mail}
cnt_cpb=${upd_cpb}
cnt_ext_ip=${upd_ext_ip}
cnt_gpg=${upd_gpg}
cnt_tmb=${upd_tmb}

while :; do

	## Volume, "VOL"
	if [ $((cnt_vol++)) -ge ${upd_vol} ]; then
		amixer -c 0 get Master | grep "Mono" | awk -F'[]%[]' '/%/ {if ($7 == "off") {print "VOL×\n"} else {printf "VOL%d%%\n", $2}}' > "${panel_fifo}" &
		cnt_vol=0
	fi

	## Offlineimap, "EMA"
	if [ $((cnt_mail++)) -ge ${upd_mail} ]; then
		printf "%s%s\n" "EMA" "$(find $HOME/.mail/*/INBOX/new -type f 2>/dev/null | wc -l)" > "${panel_fifo}"
		cnt_mail=0
	fi

	## Control Pianobar, "CPB"
	if [ $((cnt_cpb++)) -ge ${upd_cpb} ]; then
		printf "%s%s\n" "CPB" "$(grep -qxs 1 $HOME/.config/pianobar/isplaying && cat $HOME/.config/pianobar/nowplaying)" > "${panel_fifo}"
		cnt_cpb=0
	fi

	## Thinkpad Milti Battery, "TMB"
	if [ ${thinkpad_battery} -eq 1 ]; then
		if [ $((cnt_tmb++)) -ge ${upd_tmb} ]; then
			printf "%s%s\n" "TMB" "$(paste -d = /sys/class/power_supply/BAT{0..1}/uevent | awk '/ENERGY_FULL=/||/ENERGY_NOW=/||/STATUS/ {split($0,a,"="); if(a[2]~/Discharging/||a[4]~/Disharging/){CHARGE="D"} else if(a[2]~/Charging/||a[4]~/Charging/){CHARGE="C"} else if (a[2]~/Full/||a[4]~/Full/){CHARGE="F"}; if(a[1]~/FULL/){FULL=a[2]+a[4]}; if(a[1]~/NOW/){NOW=a[2]+a[4]};} END {PERC=(NOW/FULL)*100; printf("%.0f %s", PERC, CHARGE)}')" > "${panel_fifo}"
			cnt_tmp=0
		fi
	fi

	## GPG Check, "GPG"
	if [ $((cnt_gpg++)) -ge ${upd_gpg} ]; then
		export DISPLAY=''
		printf "%s%s\n" "GPG" "$(echo "1234" | gpg2 --batch -o /dev/null --local-user ${gpg_key} -as - 2>/dev/null && echo "1" || echo "0")" > "${panel_fifo}"
		cnt_gpg=0
	fi

	## External IP
	if [ $((cnt_ext_ip++)) -ge ${upd_ext_ip} ]; then
		printf "%s%s\n" "EXT" "$(wget --no-proxy http://checkip.dyndns.org/ -q -O - | grep -Eo '\<[[:digit:]]{1,3}(\.[[:digit:]]{1,3}){3}\>' || echo 'err')" > "${panel_fifo}"
		cnt_ext_ip=0
	fi

	## Finally, wait 1 second
	sleep 1s;

done &

#### LOOP FIFO

cat "${panel_fifo}" | $(dirname $0)/i3_lemonbar_parser.sh \
	| lemonbar -p -f "${font}" -f "${iconfont}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" &

wait

