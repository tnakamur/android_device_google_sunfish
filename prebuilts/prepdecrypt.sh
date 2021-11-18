#!/system/bin/sh

relink()
{
	fname=$(basename "$1")
	target="/sbin/$fname"
	sed 's|/system/bin/linker64|///////sbin/linker64|' "$1" > "$target"
	chmod 755 $target
}

finish()
{
	#umount /v
	#umount /s
	#rmdir /v
	#rmdir /s
	#mount /v /vendor
	#mount /s/system /system
	setprop prep.decrypt 1
	exit 0
}

suffix=$(getprop ro.boot.slot_suffix)
if [ -z "$suffix" ]; then
	suf=$(getprop ro.boot.slot)
	suffix="_$suf"
fi
compat_xml_path="/system_root/system/etc/vintf/"
twrp_vintf_path="/sbin/vintf/manifest/"
mkdir -p $twrp_vintf_path
cp $compat_xml_path/compatibility_matrix*xml $twrp_vintf_path
device_codename=$(getprop ro.boot.hardware)
is_fastboot_twrp=$(getprop ro.boot.fastboot)
resetprop ro.build.version.release "20.1.0"
resetprop ro.build.version.security_patch "2099-12-31"
resetprop ro.vendor.build.security_patch "2099-12-31"
finish
exit 0
