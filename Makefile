INSTALL_TARGET_PROCESSES = niconico

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FixNicoCrash

FixNicoCrash_FILES = Tweak.xm
FixNicoCrash_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
