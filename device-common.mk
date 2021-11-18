#
# Copyright (C) 2019 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# define hardware platform
PRODUCT_PLATFORM := sm7150

include device/google/sunfish/device.mk

# Set Vendor SPL to match platform
VENDOR_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

PRODUCT_PROPERTY_OVERRIDES += vendor.audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += vendor.audio_hal.period_multiplier=2
PRODUCT_PROPERTY_OVERRIDES += af.fast_track_multiplier=1

# Enable AAudio MMAP/NOIRQ data path.
# 1 is AAUDIO_POLICY_NEVER  means only use Legacy path.
# 2 is AAUDIO_POLICY_AUTO   means try MMAP then fallback to Legacy path.
# 3 is AAUDIO_POLICY_ALWAYS means only use MMAP path.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_policy=2
# 1 is AAUDIO_POLICY_NEVER  means only use SHARED mode
# 2 is AAUDIO_POLICY_AUTO   means try EXCLUSIVE then fallback to SHARED mode.
# 3 is AAUDIO_POLICY_ALWAYS means only use EXCLUSIVE mode.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_exclusive_policy=2

# Increase the apparent size of a hardware burst from 1 msec to 2 msec.
# A "burst" is the number of frames processed at one time.
# That is an increase from 48 to 96 frames at 48000 Hz.
# The DSP will still be bursting at 48 frames but AAudio will think the burst is 96 frames.
# A low number, like 48, might increase power consumption or stress the system.
PRODUCT_PROPERTY_OVERRIDES += aaudio.hw_burst_min_usec=2000

# A2DP offload enabled for compilation
AUDIO_FEATURE_ENABLED_A2DP_OFFLOAD := true

# A2DP offload supported
PRODUCT_PROPERTY_OVERRIDES += \
ro.bluetooth.a2dp_offload.supported=true

# A2DP offload disabled (UI toggle property)
PRODUCT_PROPERTY_OVERRIDES += \
persist.bluetooth.a2dp_offload.disabled=false

# A2DP offload DSP supported encoder list
PRODUCT_PROPERTY_OVERRIDES += \
persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac

# Enable AAC frame ctl for A2DP sinks
PRODUCT_PROPERTY_OVERRIDES += \
persist.vendor.bt.aac_frm_ctl.enabled=true

# Set lmkd options
PRODUCT_PRODUCT_PROPERTIES += \
	ro.config.low_ram = false \
	ro.lmk.log_stats = true \

# charger
PRODUCT_PRODUCT_PROPERTIES += \
	ro.charger.enable_suspend=true

# Modem loging file
PRODUCT_COPY_FILES += \
    device/google/sunfish/init.logging.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_PLATFORM).logging.rc

# Pixelstats broken mic detection
PRODUCT_PROPERTY_OVERRIDES += vendor.audio.mic_break=true

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.use_color_management=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.has_wide_color_display=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.has_HDR_display=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.protected_contents=true

# Must align with HAL types Dataspace
# The data space of wide color gamut composition preference is Dataspace::DISPLAY_P3
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.wcg_composition_dataspace=143261696

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Set thermal warm reset
PRODUCT_PRODUCT_PROPERTIES += \
    ro.thermal_warmreset = true \

# Audio low latency feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml

# Pro audio feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml

PRODUCT_PACKAGES += \
    dmabuf_dump

# Set the default property of tcpdump_logger on userdebug/eng ROM.
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_PROPERTY_OVERRIDES += \
        persist.vendor.tcpdump.log.alwayson=false \
        persist.vendor.tcpdump.log.br_num=5
endif

# Disable Rescue Party on userdebug & eng build
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true
endif

# Enable Incremental on the device via kernel module
PRODUCT_PROPERTY_OVERRIDES += \
        ro.incremental.enable=module:/vendor/lib/modules/incrementalfs.ko

#TWRP
PRODUCT_COPY_FILES += \
    device/google/sunfish/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc \
    device/google/sunfish/prebuilts/ftm5.ko:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/ftm5.ko \
    device/google/sunfish/prebuilts/heatmap.ko:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/heatmap.ko \
    device/google/sunfish/prebuilts/touchdriver.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/touchdriver.sh \
    device/google/sunfish/prebuilts/android.hardware.gatekeeper@1.0-service-qti:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.gatekeeper@1.0-service-qti \
    device/google/sunfish/prebuilts/android.hardware.keymaster@4.1-service.citadel:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.keymaster@4.1-service.citadel \
    device/google/sunfish/prebuilts/citadeld::$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/citadeld \
    device/google/sunfish/prebuilts/qseecomd::$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/qseecomd \
    device/google/sunfish/prebuilts/android.hardware.keymaster@4.0-service-qti:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.keymaster@4.0-service-qti \
    device/google/sunfish/prebuilts/android.hardware.weaver@1.0-service.citadel:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.weaver@1.0-service.citadel \
    device/google/sunfish/prebuilts/time_daemon:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/time_daemon \
    device/google/sunfish/prebuilts/compatibility_matrix.1.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.1.xml \
    device/google/sunfish/prebuilts/compatibility_matrix.5.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.5.xml \
    device/google/sunfish/prebuilts/compatibility_matrix.2.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.2.xml \
    device/google/sunfish/prebuilts/compatibility_matrix.legacy.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.legacy.xml \
    device/google/sunfish/prebuilts/compatibility_matrix.3.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.3.xml \
    device/google/sunfish/prebuilts/compatibility_matrix.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.xml \
    device/google/sunfish/prebuilts/compatibility_matrix.4.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.4.xml \
    device/google/sunfish/prebuilts/systemmanifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/manifest.xml \
    device/google/sunfish/prebuilts/vendormanifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest.xml \
    device/google/sunfish/prebuilts/libqtikeymaster4.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqtikeymaster4.so \
    device/google/sunfish/prebuilts/libkeymasterdeviceutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymasterdeviceutils.so \
    device/google/sunfish/prebuilts/libkeymasterutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymasterutils.so \
    device/google/sunfish/prebuilts/libnosprotos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnosprotos.so \
    device/google/sunfish/prebuilts/vendor-pixelatoms-cpp.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/vendor-pixelatoms-cpp.so \
    device/google/sunfish/prebuilts/libQSEEComAPI.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libQSEEComAPI.so \
    device/google/sunfish/prebuilts/android.hardware.authsecret@1.0-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.authsecret@1.0-impl.nos.so \
    device/google/sunfish/prebuilts/libprotobuf-cpp-full-3.9.1.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libprotobuf-cpp-full-3.9.1.so \
    device/google/sunfish/prebuilts/libqcbor.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqcbor.so \
    device/google/sunfish/prebuilts/libdrmfs.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdrmfs.so \
    device/google/sunfish/prebuilts/libdiag.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdiag.so \
    device/google/sunfish/prebuilts/libnos_citadeld_proxy.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnos_citadeld_proxy.so \
    device/google/sunfish/prebuilts/libnos_client_citadel.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnos_client_citadel.so \
    device/google/sunfish/prebuilts/nos_app_avb.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/nos_app_avb.so \
    device/google/sunfish/prebuilts/nos_app_keymaster.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/nos_app_keymaster.so \
    device/google/sunfish/prebuilts/libprotobuf-cpp-lite-3.9.1.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libprotobuf-cpp-lite-3.9.1.so \
    device/google/sunfish/prebuilts/nos_app_weaver.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/nos_app_weaver.so \
    device/google/sunfish/prebuilts/libnos_datagram_citadel.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnos_datagram_citadel.so \
    device/google/sunfish/prebuilts/android.hardware.keymaster@4.1-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.keymaster@4.1-impl.nos.so \
    device/google/sunfish/prebuilts/android.hardware.weaver@1.0-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.weaver@1.0-impl.nos.so \
    device/google/sunfish/prebuilts/android.hardware.oemlock@1.0-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.oemlock@1.0-impl.nos.so \
    device/google/sunfish/prebuilts/pixelpowerstats_provider_aidl_interface-V1-cpp.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/pixelpowerstats_provider_aidl_interface-V1-cpp.so \
    device/google/sunfish/prebuilts/libnos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnos.so \
    device/google/sunfish/prebuilts/libqmi_cci.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqmi_cci.so \
    device/google/sunfish/prebuilts/librpmb.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/librpmb.so \
    device/google/sunfish/prebuilts/libssd.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libssd.so \
    device/google/sunfish/prebuilts/libops.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libops.so \
    device/google/sunfish/prebuilts/libdisplayconfig.qti.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdisplayconfig.qti.so \
    device/google/sunfish/prebuilts/libGPreqcancel.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libGPreqcancel.so \
    device/google/sunfish/prebuilts/libqisl.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqisl.so \
    device/google/sunfish/prebuilts/libGPreqcancel_svc.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libGPreqcancel_svc.so \
    device/google/sunfish/prebuilts/libdrmtime.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdrmtime.so \
    device/google/sunfish/prebuilts/libsecureui.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libsecureui.so \
    device/google/sunfish/prebuilts/libqmi_common_so.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqmi_common_so.so \
    device/google/sunfish/prebuilts/libStDrvInt.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libStDrvInt.so \
    device/google/sunfish/prebuilts/libtime_genoff.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libtime_genoff.so \
    device/google/sunfish/prebuilts/libqmi_encdec.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqmi_encdec.so \
    device/google/sunfish/prebuilts/android.hardware.gatekeeper@1.0-impl-qti.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl-qti.so \
    device/google/sunfish/prebuilts/prepdecrypt.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/prepdecrypt.sh \
    device/google/sunfish/prebuilts/twrp.flags:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/twrp.flags

