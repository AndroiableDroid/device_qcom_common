# Configure HAL pathmaps and HAL-specific flags

# Platform names
MSMNILE := msmnile #SM8150
MSMSTEPPE := sm6150
TRINKET := trinket #SM6125

B_FAMILY := msm8226 msm8610 msm8974
B64_FAMILY := msm8992 msm8994
BR_FAMILY := msm8909 msm8916
UM_3_18_FAMILY := msm8937 msm8953 msm8996
UM_4_4_FAMILY := msm8998 sdm660
UM_4_9_FAMILY := sdm845 sdm710
UM_4_14_FAMILY := $(MSMNILE) $(MSMSTEPPE) $(TRINKET)
UM_PLATFORMS := $(UM_3_18_FAMILY) $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY)

# Legacy audio
ifneq ($(filter msm7x27a msm7x30 msm8660 msm8960,$(TARGET_BOARD_PLATFORM)),)
    TARGET_USES_QCOM_BSP_LEGACY := true
    # Enable legacy audio functions
    ifeq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
        USE_CUSTOM_AUDIO_POLICY := 1
    endif
endif

# UM platforms no longer need this set on O+
ifneq ($(filter $(B_FAMILY) $(B64_FAMILY) $(BR_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_USES_QCOM_BSP := true
endif

# Enable color metadata for every UM platform
ifneq ($(filter $(UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    TARGET_USES_COLOR_METADATA := true
endif

# Mark GRALLOC_USAGE_PRIVATE_10BIT_TP as valid gralloc bits on UM platforms that support it
ifeq ($(call is-board-platform-in-list, $(UM_4_9_FAMILY) $(UM_4_14_FAMILY)),true)
    TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 27)
endif

# Configure HAL variant
ifneq ($(filter $(B_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(B_FAMILY)
    QCOM_HARDWARE_VARIANT := msm8974
else ifneq ($(filter $(B64_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(B64_FAMILY)
    QCOM_HARDWARE_VARIANT := msm8994
else ifneq ($(filter $(BR_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(BR_FAMILY)
    QCOM_HARDWARE_VARIANT := msm8916
else ifneq ($(filter $(UM_3_18_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_3_18_FAMILY)
    QCOM_HARDWARE_VARIANT := msm8996
else ifneq ($(filter $(UM_4_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_4_4_FAMILY)
    QCOM_HARDWARE_VARIANT := msm8998
else ifneq ($(filter $(UM_4_9_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_4_9_FAMILY)
    QCOM_HARDWARE_VARIANT := sdm845
else ifneq ($(filter $(UM_4_14_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_4_14_FAMILY)
    QCOM_HARDWARE_VARIANT := sm8150
else
    MSM_VIDC_TARGET_LIST := $(TARGET_BOARD_PLATFORM)
    QCOM_HARDWARE_VARIANT := $(TARGET_BOARD_PLATFORM)
endif

PRODUCT_SOONG_NAMESPACES += \
    hardware/qcom/audio-caf/$(QCOM_HARDWARE_VARIANT) \
    hardware/qcom/display-caf/$(QCOM_HARDWARE_VARIANT) \
    hardware/qcom/media-caf/$(QCOM_HARDWARE_VARIANT)

$(call set-device-specific-path,AUDIO,audio,hardware/qcom/audio/$(QCOM_HARDWARE_VARIANT))
$(call set-device-specific-path,DISPLAY,display,hardware/qcom/display/$(QCOM_HARDWARE_VARIANT))
$(call set-device-specific-path,MEDIA,media,hardware/qcom/media/$(QCOM_HARDWARE_VARIANT))

$(call set-device-specific-path,DATA_IPA_CFG_MGR,data-ipa-cfg-mgr,vendor/qcom/opensource/data-ipa-cfg-mgr)
$(call set-device-specific-path,GPS,gps,hardware/qcom/gps)
$(call set-device-specific-path,LOC_API,loc-api,vendor/qcom/opensource/location)
$(call set-device-specific-path,DATASERVICES,dataservices,vendor/qcom/opensource/dataservices)
$(call set-device-specific-path,POWER,power,vendor/qcom/opensource/power)
$(call set-device-specific-path,THERMAL,thermal,vendor/qcom/opensource/thermal-hal)
$(call set-device-specific-path,VR,vr,hardware/qcom/vr)
