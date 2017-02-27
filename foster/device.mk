#
# Copyright (C) 2014 The CyanogenMod Project
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

TEGRA_TOP := vendor/nvidia/tegra
REFERENCE_DEVICE := shieldtablet

$(call inherit-product-if-exists, vendor/nvidia/tegra/core/android/t124/full.mk)
$(call inherit-product-if-exists, vendor/nvidia/tegra/core/nvidia-tegra-vendor.mk)
$(call inherit-product-if-exists, vendor/nvidia/shieldtablet/shieldtablet-vendor.mk)

# Need AppWidget permission to prevent from Launcher's crash.
# TODO(pattjin): Remove this when the TV Launcher is used, which does not support AppWidget.
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml

# Include drawables for various densities.
PRODUCT_AAPT_CONFIG := normal large xlarge tvdpi hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi
TARGET_SCREEN_HEIGHT := 1080
TARGET_SCREEN_WIDTH := 1920

PRODUCT_PROPERTY_OVERRIDES += \
ro.com.google.clientidbase=android-nvidia

PRODUCT_CHARACTERISTICS := tv
TARGET_TEGRA_VERSION := t124
TARGET_TEGRA_MODEM := icera
TARGET_TEGRA_TOUCH := raydium

$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

$(call inherit-product-if-exists, vendor/nvidia/shieldtablet/shieldtablet-vendor.mk)

PRODUCT_SYSTEM_PROPERTY_BLACKLIST := ro.product.name

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayouts/tegra-kbc.kl:system/usr/keylayout/tegra-kbc.kl \
    $(LOCAL_PATH)/keylayouts/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/keylayouts/AliTV_Remote_V1_Airmouse.kl:system/usr/keylayout/AliTV_Remote_V1_Airmouse.kl \
    $(LOCAL_PATH)/keylayouts/AliTV_Remote_V1_Airmouse.idc:system/usr/idc/AliTV_Remote_V1_Airmouse.idc

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    device/nvidia/foster/overlay

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.tegra \
    init.recovery.tegra.rc \
    init.tegra.rc \
    init.tegra_common.rc \
    power.tegra.rc \
    ueventd.tegra.rc

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:system/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:system/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

# NVIDIA
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/permissions/com.nvidia.feature.xml:system/etc/permissions/com.nvidia.feature.xml \
    $(LOCAL_PATH)/permissions/com.nvidia.feature.opengl4.xml:system/etc/permissions/com.nvidia.feature.opengl4.xml \
    $(LOCAL_PATH)/permissions/com.nvidia.nvsi.xml:system/etc/permissions/com.nvidia.nvsi.xml

# Media config
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    $(LOCAL_PATH)/audio/media_codecs.xml:system/etc/media_codecs.xml \
    $(LOCAL_PATH)/audio/media_codecs_performance.xml:system/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/audio/media_profiles.xml:system/etc/media_profiles.xml

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audioConfig_qvoice_icera_pc400.xml:system/etc/audioConfig_qvoice_icera_pc400.xml \
    $(LOCAL_PATH)/audio/nvaudio_conf.xml:system/etc/nvaudio_conf.xml \
    $(LOCAL_PATH)/audio/nvaudio_fx.xml:system/etc/nvaudio_fx.xml

# specific management of audio_policy.conf
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_policy.conf:system/etc/audio_policy.conf

PRODUCT_PROPERTY_OVERRIDES += \
    media.stagefright.cache-params=10240/20480/15 \
    persist.sys.media.avsync=true \
    media.aac_51_output_enabled=true

# GPS
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/comms/gpsconfig.xml:system/etc/gps/gpsconfig.xml \
    $(LOCAL_PATH)/comms/gps.conf:system/etc/gps.conf

# Bluetooth
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/comms/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf

# Camera
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/camera/nvcamera.conf:system/etc/nvcamera.conf \
    $(LOCAL_PATH)/camera/model_frontal.xml:system/etc/model_frontal.xml

# Wifi
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/comms/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf

# Leanback Launcher
PRODUCT_PACKAGES += \
    AppDrawer \
    LeanbackLauncher \
    LeanbackCustomizer \
    LeanbackIme \
    TvProvider \
    TvSettings \
    tv_input.default \
    TV \
    LiveTv

PRODUCT_PACKAGES += libhardware_legacy
PRODUCT_PACKAGES += libwpa_client
PRODUCT_PACKAGES += hostapd
PRODUCT_PACKAGES += dhcpcd.conf
PRODUCT_PACKAGES += wpa_supplicant
PRODUCT_PACKAGES += wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf

# Nvidia packages
PRODUCT_PACKAGES += \
    libstagefrighthw \
    hdmi_cec.tegra \
    vulkan.tegra \
    audio.primary.tegra \
    audio.a2dp.default \
    audio.usb.default \
    libaudiopolicymanager \
    audio.nvwc.tegra \
    power.tegra \
    setup_fs \
    drmserver \
    Gallery2 \
    libdrmframework_jni \
    overlaymon \
    e2fsck \
    charger \
    charger_res_images

# Radio Interface
PRODUCT_PACKAGES += rild

# Power
PRODUCT_PACKAGES += power.tegra

# Compatibility
PRODUCT_PACKAGES += libshim_icu55 \
                    libshim_nvcamera \
                    libshim_gpsd
# Leanback Gapps
$(call inherit-product, vendor/google/jetson/jetson-vendor.mk)
$(call inherit-product-if-exists, vendor/google/atv/atv-vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_no_telephony.mk)

# Wireless Controller
#$(call inherit-product-if-exists, vendor/nvidia/shield_common/blake-blobs.mk)

# Console Mode
$(call inherit-product-if-exists, vendor/nvidia/shield_common/consolemode-blobs.mk)

# Stock Camera
$(call inherit-product-if-exists, vendor/nvidia/shield_common/nvcamera-blobs.mk)

$(call inherit-product, device/nvidia/shield-common/shield.mk)
