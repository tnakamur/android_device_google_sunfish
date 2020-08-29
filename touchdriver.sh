#!/sbin/sh

fastboot=$(getprop ro.boot.bootreason | cut -d, -F2)
if [[ $fastboot == bootloader || $fastboot == "longkey" || $fastboot == "reboot" ]]
then
	insmod /sbin/heatmap.ko
	insmod /sbin/ftm5.ko
fi
