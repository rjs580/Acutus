ARCHS = armv7 arm64

TARGET = iphone:clang:latest:7.0

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

BUNDLE_NAME = AcutusPrefs
AcutusPrefs_CFLAGS = -fobjc-arc
AcutusPrefs_FILES = AcutusPrefsListController.m
AcutusPrefs_INSTALL_PATH = /Library/PreferenceBundles
AcutusPrefs_FRAMEWORKS = Foundation UIKit
AcutusPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AcutusPrefs.plist$(ECHO_END)
