export THEOS_DEVICE_IP=10.0.2.8
SDKVERSION = 5.0
include /usr/local/theos/makefiles/common.mk

LIBRARY_NAME = SimpleVolumeSlider
SimpleVolumeSlider_FILES = SimpleVolumeSlider.m
SimpleVolumeSlider_INSTALL_PATH = /System/Library/WeeAppPlugins/SimpleVolumeSlider.bundle
SimpleVolumeSlider_FRAMEWORKS = UIKit MediaPlayer CoreGraphics
SimpleVolumeSlider_PRIVATE_FRAMEWORKS = BulletinBoard

include $(THEOS_MAKE_PATH)/library.mk

after-stage::
	mv _/System/Library/WeeAppPlugins/SimpleVolumeSlider.bundle/SimpleVolumeSlider.dylib _/System/Library/WeeAppPlugins/SimpleVolumeSlider.bundle/SimpleVolumeSlider
	cp -a *.png _/System/Library/WeeAppPlugins/SimpleVolumeSlider.bundle/
	cp Info.plist _/System/Library/WeeAppPlugins/SimpleVolumeSlider.bundle/
	cp *.strings _/System/Library/WeeAppPlugins/SimpleVolumeSlider.bundle/