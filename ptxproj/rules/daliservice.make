# -*-makefile-*-
#
# Copyright (C) 2024 Philipp Hundsdörfer
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DALISERVICE) += daliservice

#
# Paths and names
#

DALISERVICE_VERSION        := 0.2.1
DALISERVICE_MD5            :=
DALISERVICE                := daliservice
DALISERVICE_SRC_DIR        := $(PTXDIST_WORKSPACE)/wago_intern/daliservice
DALISERVICE_URL            := file://$(DALISERVICE_SRC_DIR)
DALISERVICE_BUILDCONFIG    := Release
DALISERVICE_BUILDROOT_DIR  := $(BUILDDIR)/$(DALISERVICE)-$(DALISERVICE_VERSION)
DALISERVICE_DIR            := $(DALISERVICE_BUILDROOT_DIR)/src
DALISERVICE_BIN_DIR        := $(DALISERVICE_BUILDROOT_DIR)/bin/$(DALISERVICE_BUILDCONFIG)
DALISERVICE_LICENSE        := WAGO
DALISERVICE_BIN            := DALIService.elf.$(DALISERVICE_VERSION)
DALISERVICE_PATH           := PATH=$(CROSS_PATH)
DALISERVICE_CONF_TOOL      := NO
DALISERVICE_MAKE_ENV       := $(CROSS_ENV) \
BUILDCONFIG=$(DALISERVICE_BUILDCONFIG) \
BIN_DIR=$(DALISERVICE_BIN_DIR) \
SCRIPT_DIR=$(PTXDIST_SYSROOT_HOST)/usr/lib/ct-build

DALISERVICE_PACKAGE_NAME := $(DALISERVICE)_$(DALISERVICE_VERSION)_$(PTXDIST_IPKG_ARCH_STRING)
DALISERVICE_PLATFORMCONFIGPACKAGEDIR := $(PTXDIST_PLATFORMCONFIGDIR)/packages


# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/daliservice.extract:
	@$(call targetinfo)
	@mkdir -p $(DALISERVICE_BUILDROOT_DIR)	
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES 
	@if [ ! -L $(DALISERVICE_DIR) ]; then \
		ln -s $(DALISERVICE_SRC_DIR) $(DALISERVICE_DIR); \
	fi
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Extract.post
# ----------------------------------------------------------------------------

ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
$(STATEDIR)/daliservice.extract.post:
	@$(call targetinfo)
	@$(call touch)
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/daliservice.prepare:
	@$(call targetinfo)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES 
	@$(call world/prepare, DALISERVICE)
	@$(call xslt_compile, $(DALISERVICE_DIR)/xml/DALIService.xml)
	@rm 	$(DALISERVICE_DIR)/xml/diagnostics.dtd
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/daliservice.compile:
	@$(call targetinfo)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
	cp $(DALISERVICE_SRC_DIR)/src/sys/DSshm.h $(PTXCONF_SYSROOT_TARGET)/usr/include/DSshm.h
	cp $(DALISERVICE_SRC_DIR)/src/sys/DStime.h $(PTXCONF_SYSROOT_TARGET)/usr/include/DStime.h
	cp $(DALISERVICE_SRC_DIR)/src/sys/DStransfer.h $(PTXCONF_SYSROOT_TARGET)/usr/include/DStransfer.h
	cp $(DALISERVICE_SRC_DIR)/src/legacy/mailbox20/common/mbx2_intern.h $(PTXCONF_SYSROOT_TARGET)/usr/include/mbx2_intern.h
	@$(call world/compile, DALISERVICE)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/daliservice.install:
	@$(call targetinfo)

ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
#   BSP mode: install by extracting tgz file
	@mkdir -p $(DALISERVICE_PKGDIR) && \
  tar xvzf $(DALISERVICE_PLATFORMCONFIGPACKAGEDIR)/$(DALISERVICE_PACKAGE_NAME).tgz -C $(DALISERVICE_PKGDIR)
else	
# 	normal mode, call "make install"	
	
	@$(call world/install, DALISERVICE)
	
ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_RELEASE
#   # save install directory to tgz for BSP mode
	@mkdir -p $(DALISERVICE_PLATFORMCONFIGPACKAGEDIR)
	@cd $(DALISERVICE_PKGDIR) && tar cvzf $(DALISERVICE_PLATFORMCONFIGPACKAGEDIR)/$(DALISERVICE_PACKAGE_NAME).tgz *
endif
endif
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/daliservice.targetinstall:
	@$(call targetinfo)

	@$(call install_init, daliservice)
	@$(call install_fixup, daliservice,PRIORITY,optional)
	@$(call install_fixup, daliservice,SECTION,base)
	@$(call install_fixup, daliservice,AUTHOR,"Philipp Hundsdörfer")
	@$(call install_fixup, daliservice,DESCRIPTION,missing)

ifneq ($(call remove_quotes, $( PTXCONF_WAGO_DALI_SERVICE_DAEMON_BBINIT_LINK)),)
	@$(call install_link, daliservice, \
		/etc/init.d/DALIService, \
		/etc/rc.d/$(PTXCONF_WAGO_DALI_SERVICE_DAEMON_BBINIT_LINK))
endif
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
	@$(call install_copy, daliservice, 0, 0, 0755, $(DALISERVICE_BIN_DIR)/DALIService.elf, /usr/bin/DALIService)
else
	@$(call install_copy, daliservice, 0, 0, 0755, $(DALISERVICE_PKGDIR)/usr/bin/DALIService, /usr/bin/DALIService)
endif
	@$(call install_copy, daliservice, 0, 0, 0755, -, /etc/init.d/DALIService)
ifdef PTXCONF_WAGO_DALI_SERVICE_DAEMON_BBINIT_LINK
	@$(call install_link, daliservice, \
	  /etc/init.d/DALIService, \
	  /etc/rc.d/$(PTXCONF_WAGO_DALI_SERVICE_DAEMON_BBINIT_LINK))
endif

	@$(call install_finish, daliservice)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/daliservice.clean:
	@$(call targetinfo)
	@if [ -d $(DALISERVICE_DIR) ]; then \
	  $(DALISERVICE_MAKE_ENV) $(DALISERVICE_PATH) $(MAKE) $(MFLAGS) -C $(DALISERVICE_DIR) clean; \
	fi
	@$(call clean_pkg, DALISERVICE)
	@rm -rf $(DALISERVICE_BUILDROOT_DIR)
	@$(call xslt_clean, $(DALISERVICE_DIR)/xml/DALIService.xml)

# vim: syntax=make
