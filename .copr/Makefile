# For COPR, build method "make srpm": packs the checked-out commit as the
# source the spec expects, fixes the spec's release and builds the source RPM.

NAME := pla8ma-show-desktop
TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
outdir ?= $(TOP)/.copr/out

srpm:
	dnf -y install git rpm-build
	mkdir -p $(outdir)
	git -c safe.directory='*' -C $(TOP) archive --format=tar.gz \
		--prefix=$(NAME)-main/ -o $(outdir)/$(NAME)-main.tar.gz HEAD
	sed -e "s/^%global buildstamp .*/%global buildstamp $$(date -u +%Y%m%d%H%M)/" \
		$(TOP)/packaging/fedora/$(NAME).spec > $(outdir)/$(NAME).spec
	rpmbuild -bs --define "_sourcedir $(outdir)" --define "_srcrpmdir $(outdir)" \
		$(outdir)/$(NAME).spec
