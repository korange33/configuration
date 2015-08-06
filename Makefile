all: build-firmware

link-srcdir:
	ln -s $(MARLINMASTER)Marlin src

clean-pde:
	rm src/Marlin.pde

build-firmware: link-srcdir clean-pde config
	ino build -m mega2560

upload-arduino:
	arduino --verify $(MARLINMASTER)Marlin/Marlin.ino
	arduino --board mega:cpu:atmega2560 --port $(ttyACM) --upload $(MARLINMASTER)Marlin/Marlin.ino
upload:
	ls -tr /dev/ttyACM* | tail -1
	ino upload -p /dev/ttyACM3 -d mega2560

ttyACM=$(shell ls -tr /dev/ttyACM* | tail -1)
MARLINMASTER=MarlinDev-master/
CONF=$(MARLINMASTER)Marlin/Configuration.h

update: config
	wget https://github.com/MarlinFirmware/MarlinDev/archive/master.zip
	unzip master

config:
	cp $(MARLINMASTER)Marlin/example_configurations/delta/kossel_mini/Configuration.h $(MARLINMASTER)Marlin/
	cp $(MARLINMASTER)Marlin/example_configurations/delta/kossel_mini/Configuration_adv.h $(MARLINMASTER)Marlin/
	sed -i s/'X_MIN_ENDSTOP_INVERTING = false'/'X_MIN_ENDSTOP_INVERTING = true'/g $(CONF)
	sed -i s/'Y_MIN_ENDSTOP_INVERTING = false'/'Y_MIN_ENDSTOP_INVERTING = true'/g $(CONF)
	sed -i s/'Z_MIN_ENDSTOP_INVERTING = false'/'Z_MIN_ENDSTOP_INVERTING = true'/g $(CONF)
	sed -i 's/MANUAL_Z_HOME_POS 250/MANUAL_Z_HOME_POS 296.5/g' $(CONF)
	sed -i 's/TEMP_SENSOR_0 7/TEMP_SENSOR_0 13/g' $(CONF)
	sed -i 's/TEMP_SENSOR_BED 11/TEMP_SENSOR_BED 0/g' $(CONF)

.PHONY: clean

clean:
	rm -rf $(MARLINMASTER) master.zip
