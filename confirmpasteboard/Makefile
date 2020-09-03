TARGET = iphone:clang:12.2:12.2
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ConfirmPasteboard

ConfirmPasteboard_FILES = CPPRootListController.m
ConfirmPasteboard_FRAMEWORKS = UIKit
ConfirmPasteboard_PRIVATE_FRAMEWORKS = Preferences
ConfirmPasteboard_INSTALL_PATH = /Library/PreferenceBundles
ConfirmPasteboard_CFLAGS = -fobjc-arc
ConfirmPasteboard_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/bundle.mk
