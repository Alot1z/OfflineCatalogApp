ARCHS = arm64
TARGET = iphone:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = OfflineCatalogApp

OfflineCatalogApp_FILES = Tweak.xm
OfflineCatalogApp_INSTALL_PATH = /Applications/OfflineCatalogApp.app
OfflineCatalogApp_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/bundle.mk

after-stage::
	@echo "Signing app binary with entitlements..."
	ldid -Sentitlements.plist $(THEOS_STAGING_DIR)/Applications/OfflineCatalogApp.app/OfflineCatalogApp
