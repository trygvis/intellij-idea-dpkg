# Written by Trygve Laugstøl <trygvis@inamo.no>
# TODO: Support publishing the packages and run dpkg-scanpackages
# TODO: Write notes on how to use
# TODO: Support for signing the packages

ifeq ($(FLAVOR),IC)
FLAVOR_LOWER=ic
OTHER_FLAVOR=IU
OTHER_FLAVOR_LOWER=iu
else
FLAVOR_LOWER=iu
OTHER_FLAVOR=IC
OTHER_FLAVOR_LOWER=ic
endif

ifdef REVISION
V=$(VERSION)-$(REVISION)
else
V=$(VERSION)-1
endif

PWD=$(shell pwd)
FAKEROOT=fakeroot -i fakeroot.save -s fakeroot.save

all: check-settings clean intellij-idea-$(FLAVOR_LOWER)-$(V).deb

check-settings:
	@if [ -z "$(FLAVOR)" ]; then echo "Make sure FLAVOR is set when running make; for example: make FLAVOR=IU VERSION=90.162"; exit 1; fi
	@if [ "$(FLAVOR)" != "IU" -a "$(FLAVOR)" != "IC" ]; then echo "Make sure FLAVOR is set to either 'IU' or 'IC'."; exit 1; fi
	@if [ -z "$(VERSION)" ]; then echo "Make sure VERSION is set when running make; for example: make FLAVOR=IU VERSION=90.162"; exit 1; fi
	@if [ "$(REVISION)" = "1" ]; then echo "REVISION has to be higher than 1; for example: make FLAVOR=IU VERSION=90.162 REVISION=2"; exit 1; fi

clean:
	@echo Cleaning
	@rm -rf root *.save

intellij-idea-$(FLAVOR_LOWER)-$(V).deb: root/DEBIAN/control root/usr/bin/idea root/usr/share/intellij/idea-$(FLAVOR)-$(VERSION)
	@touch fakeroot.save
	@$(FAKEROOT) -- chown -R root:root root/
	@$(FAKEROOT) -- dpkg-deb -b root $@

root/usr/bin/idea: idea.in
	@echo Creating $@
	@mkdir -p $(shell dirname $@)
	@sed \
		-e "s,FLAVOR,$(FLAVOR)," \
		-e "s,VERSION,$(VERSION)," \
		$< > $@
	@chmod +x $@

root/DEBIAN/control: control.in
	@echo Creating $@
	@mkdir -p $(shell dirname $@)
	@sed \
		-e "s,OTHER_FLAVOR_LOWER,$(OTHER_FLAVOR_LOWER)," \
		-e "s,OTHER_FLAVOR,$(OTHER_FLAVOR)," \
		-e "s,FLAVOR_LOWER,$(FLAVOR_LOWER)," \
		-e "s,FLAVOR,$(FLAVOR)," \
		-e "s,VERSION,$(V)," \
		$< > $@

root/usr/share/intellij/idea-$(FLAVOR)-$(VERSION): idea-$(FLAVOR)-$(VERSION).tar.gz
	@mkdir -p $(shell dirname $@)
	@echo Unpacking $?
	@(cd $(shell dirname $@); tar zxf $(PWD)/$<)

idea-$(FLAVOR)-$(VERSION).tar.gz:
	wget -O $@ http://download.jetbrains.com/idea/idea$(FLAVOR)-$(VERSION).tar.gz
