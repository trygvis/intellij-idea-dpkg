ifeq ($(FLAVOR),IC)
FLAVOR_LOWER=ic
OTHER_FLAVOR=iu
else
FLAVOR_LOWER=iu
OTHER_FLAVOR=ic
endif

PWD=$(shell pwd)
FAKEROOT=fakeroot -i fakeroot.save -s fakeroot.save

all: check-settings clean intellij-idea-$(FLAVOR_LOWER)-$(VERSION).deb

check-settings:
	@if [ -z "$(FLAVOR)" ]; then echo "Make sure FLAVOR is set when running make; for example: make FLAVOR=IU VERSION=90.162"; exit 1; fi
	@if [ "$(FLAVOR)" != "IU" -a "$(FLAVOR)" != "IC" ]; then echo "Make sure FLAVOR is set to either 'IU' or 'IC'."; exit 1; fi
	@if [ -z "$(VERSION)" ]; then echo "Make sure VERSION is set when running make; for example: make FLAVOR=IU VERSION=90.162"; exit 1; fi

clean:
	@echo Cleaning
	@rm -rf root

# The generated files has to be phony because VERSION or FLAVOR might have 
# changed and there is no way to Make to tell.
.PHONY: check-settings clean root/usr/bin/idea root/DEBIAN/control

intellij-idea-$(FLAVOR_LOWER)-$(VERSION).deb: root/DEBIAN/control root/usr/bin/idea root/usr/share/intellij/idea-$(FLAVOR)-$(VERSION)
	@$(FAKEROOT) -- chown -R root:root root/
	@$(FAKEROOT) -- dpkg-deb -b root $@

root/usr/bin/idea: idea.in
	@echo Creating $@
	@mkdir -p $(shell dirname $@)
	@cat $< | \
		sed "s,OTHER_FLAVOR,$(OTHER_FLAVOR)," | \
		sed "s,FLAVOR,$(FLAVOR)," | \
		sed "s,VERSION,$(VERSION)," | \
		cat - > $@
	@chmod +x $@

root/DEBIAN/control: control.in
	@echo Creating $@
	@mkdir -p $(shell dirname $@)
	@cat control.in | \
		sed "s,OTHER_FLAVOR,$(OTHER_FLAVOR)," | \
		sed "s,FLAVOR,$(FLAVOR_LOWER)," | \
		sed "s,VERSION,$(VERSION)," | \
		cat - > $@

root/usr/share/intellij/idea-$(FLAVOR)-$(VERSION): idea-$(FLAVOR)-$(VERSION).tar.gz
	@mkdir -p $(shell dirname $@)
	@echo Unpacking $?
	@(cd $(shell dirname $@); tar zxf $(PWD)/$<)

idea-$(FLAVOR)-$(VERSION).tar.gz:
	wget -O $@ http://download.jetbrains.com/idea/idea$(FLAVOR)-$(VERSION).tar.gz
