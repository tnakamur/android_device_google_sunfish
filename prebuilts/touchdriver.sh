#!/system/bin/sh

fastboot=$(getprop ro.boot.bootreason | cut -d, -F2)
if [[ $fastboot == "bootloader" || $fastboot == "longkey" || $fastboot == "reboot"  || $fastboot == "recovery" || $fastboot == "reboot,recovery" ]]
then
	insmod /ftm5.ko
	insmod /sec_touch.ko
fi

