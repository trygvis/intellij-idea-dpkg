# FLAVOR  =IU
# VERSION ?=90.162
# make FLAVOR=UI VERSION=90.162

PWD=$(shell pwd)

all: check-settings intellij-idea-$(FLAVOR)-$(VERSION).deb

check-settings:
	@if [ -z "$(FLAVOR)" ]; then echo "Make sure FLAVOR is set when running make; for example: make FLAVOR=IU VERSION=90.162"; exit 1; fi
	@if [ -z "$(VERSION)" ]; then echo "Make sure VERSION is set when running make; for example: make FLAVOR=IU VERSION=90.162"; exit 1; fi

clean:
	@rm -rf root

.PHONY: check-settings clean

intellij-idea-$(FLAVOR)-$(VERSION).deb: root/usr/share/intellij/idea-$(FLAVOR)-$(VERSION) root/DEBIAN/control root/usr/bin/idea
	dpkg-deb -b root $@

root/usr/bin/idea: idea.in
	@echo Creating $@
	@mkdir -p $(shell dirname $@)
	@cat $< | \
		sed "s,FLAVOR,$(FLAVOR)," | \
		sed "s,VERSION,$(VERSION)," | \
		cat - > $@
	@chmod +x $@

root/DEBIAN/control: control.in
	@echo Creating $@
	@mkdir -p $(shell dirname $@)
	@cat control.in | \
		sed "s,FLAVOR,$(FLAVOR)," | \
		sed "s,VERSION,$(VERSION)," | \
		cat - > $@

root/usr/share/intellij/idea-$(FLAVOR)-$(VERSION): idea-$(FLAVOR)-$(VERSION).tar.gz
	@mkdir -p $(shell dirname $@)
	@echo Unpacking $?
	@(cd $(shell dirname $@); tar zxf $(PWD)/$<)

idea-$(FLAVOR)-$(VERSION).tar.gz:
	wget -O $< http://download.jetbrains.com/idea/idea$(FLAVOR)-$(VERSION).tar.gz
