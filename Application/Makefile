ARCHS = armv7 arm64

TARGET = iphone:clang:latest:7.0

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = Acutus
Acutus_CFLAGS = -fobjc-arc
Acutus_FILES = Acutus.xm Reachability.m
Acutus_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore SystemConfiguration CoreFoundation
Acutus_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += acutusprefs
SUBPROJECTS += postinst
SUBPROJECTS += unicorn
SUBPROJECTS += unicorn_
SUBPROJECTS += unicorn_dos
SUBPROJECTS += unicorn_pon
include $(THEOS_MAKE_PATH)/aggregate.mk
