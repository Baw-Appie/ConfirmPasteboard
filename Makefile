TARGET = iphone:clang:12.2:12.2
ARCHS = arm64 arm64e

# INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ConfirmPasteboard

ConfirmPasteboard_FILES = Tweak.x $(wildcard *.m)
ConfirmPasteboard_CFLAGS = -fobjc-arc
ConfirmPasteboard_LIBRARIES = mryipc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += confirmpasteboard
include $(THEOS_MAKE_PATH)/aggregate.mk
