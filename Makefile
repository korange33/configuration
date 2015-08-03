all: depends

depends:
	head -28 .travis.yml
	@echo after solving dependancies, try : make build-firmware

link-srcdir:
	ln -s Marlin src

clean-pde:
	rm src/Marlin.pde

kossel-cfg:
	echo cp Marlin/

build-firmware: link-srcdir clean-pde config
	ino build -m mega2560

MARLINMASTER=MarlinDev-master/
CONF=$(MARLINMASTER)Marlin/Configuration.h

update: config
	rm -Rf MarlinDev-master/ master.zip
	wget https://github.com/MarlinFirmware/MarlinDev/archive/master.zip
	unzip master
	cd $(MARLINMASTER)
config:
	#curl --silent --show-error -o $(CONF) https://raw.githubusercontent.com/MarlinFirmware/Marlin/Development/Marlin/example_configurations/delta/kossel_mini/Configuration.h
	#curl --silent --show-error -o Marlin/Configuration_adv.h https://raw.githubusercontent.com/MarlinFirmware/Marlin/Development/Marlin/example_configurations/delta/kossel_mini/Configuration_adv.h
	cp $(MARLINMASTER)Marlin/example_configurations/delta/kossel_mini/Configuration.h $(MARLINMASTER)Marlin/
	cp $(MARLINMASTER)Marlin/example_configurations/delta/kossel_mini/Configuration_adv.h $(MARLINMASTER)Marlin/
	sed -i s/'X_MIN_ENDSTOP_INVERTING = false'/'X_MIN_ENDSTOP_INVERTING = true'/g $(CONF)
	sed -i s/'Y_MIN_ENDSTOP_INVERTING = false'/'Y_MIN_ENDSTOP_INVERTING = true'/g $(CONF)
	sed -i s/'Z_MIN_ENDSTOP_INVERTING = false'/'Z_MIN_ENDSTOP_INVERTING = true'/g $(CONF)
	sed -i 's/MANUAL_Z_HOME_POS 250/MANUAL_Z_HOME_POS 286.5/g' $(CONF)

.PHONY: clean

clean:
	rm -rf $(MARLINMASTER)
