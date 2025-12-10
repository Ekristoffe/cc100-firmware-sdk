# -*-makefile-*-
#
# Copyright (C) 2016 by Falk Werner/Jobst Wellensiek
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_CDS3_TSCDALIAPPCONNECTOR) += cds3-tscdaliappconnector

#
# Paths and names
#

CDS3_TSCDALIAPPCONNECTOR_VERSION        := 0.2.1
CDS3_TSCDALIAPPCONNECTOR_MD5            :=
CDS3_TSCDALIAPPCONNECTOR                := cds3-tscdaliappconnector
CDS3_TSCDALIAPPCONNECTOR_SRC_DIR        := $(PTXDIST_WORKSPACE)/wago_intern/codesys3-Component/cds3-tscdaliappconnector
CDS3_TSCDALIAPPCONNECTOR_URL            := file://$(CDS3_TSCDALIAPPCONNECTOR_SRC_DIR)
CDS3_TSCDALIAPPCONNECTOR_BUILDCONFIG    := Release
CDS3_TSCDALIAPPCONNECTOR_BUILDROOT_DIR  := $(BUILDDIR)/$(CDS3_TSCDALIAPPCONNECTOR)-$(CDS3_TSCDALIAPPCONNECTOR_VERSION)
CDS3_TSCDALIAPPCONNECTOR_DIR            := $(CDS3_TSCDALIAPPCONNECTOR_BUILDROOT_DIR)/src
CDS3_TSCDALIAPPCONNECTOR_BIN_DIR        := $(CDS3_TSCDALIAPPCONNECTOR_BUILDROOT_DIR)/bin/$(CDS3_TSCDALIAPPCONNECTOR_BUILDCONFIG)
CDS3_TSCDALIAPPCONNECTOR_LICENSE        := WAGO
CDS3_TSCDALIAPPCONNECTOR_BIN            := libTscDALIAppConnector.so.$(CDS3_TSCDALIAPPCONNECTOR_VERSION)
CDS3_TSCDALIAPPCONNECTOR_PATH           := PATH=$(CROSS_PATH)
CDS3_TSCDALIAPPCONNECTOR_CONF_TOOL      := NO
CDS3_TSCDALIAPPCONNECTOR_MAKE_ENV       := $(CROSS_ENV) \
PTXCONF_CDS3_RTS_TESTS=$(PTXCONF_CDS3_RTS_TESTS) \
BUILDCONFIG=$(CDS3_TSCDALIAPPCONNECTOR_BUILDCONFIG) \
BIN_DIR=$(CDS3_TSCDALIAPPCONNECTOR_BIN_DIR) \
SCRIPT_DIR=$(PTXDIST_SYSROOT_HOST)/usr/lib/ct-build

CDS3_TSCDALIAPPCONNECTOR_PACKAGE_NAME := $(CDS3_TSCDALIAPPCONNECTOR)_$(CDS3_TSCDALIAPPCONNECTOR_VERSION)_$(PTXDIST_IPKG_ARCH_STRING)
CDS3_TSCDALIAPPCONNECTOR_PLATFORMCONFIGPACKAGEDIR := $(PTXDIST_PLATFORMCONFIGDIR)/packages


# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-tscdaliappconnector.extract:
	@$(call targetinfo)
	@mkdir -p $(CDS3_TSCDALIAPPCONNECTOR_BUILDROOT_DIR)	
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES 
	@if [ ! -L $(CDS3_TSCDALIAPPCONNECTOR_DIR) ]; then \
		ln -s $(CDS3_TSCDALIAPPCONNECTOR_SRC_DIR) $(CDS3_TSCDALIAPPCONNECTOR_DIR); \
	fi
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Extract.post
# ----------------------------------------------------------------------------

ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
$(STATEDIR)/cds3-tscdaliappconnector.extract.post:
	@$(call targetinfo)
	@$(call touch)
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-tscdaliappconnector.prepare:
	@$(call targetinfo)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES 
	@$(call world/prepare, CDS3_TSCDALIAPPCONNECTOR)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-tscdaliappconnector.compile:
	@$(call targetinfo)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
	@$(call world/compile, CDS3_TSCDALIAPPCONNECTOR)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-tscdaliappconnector.install:
	@$(call targetinfo)

ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
#   BSP mode: install by extracting tgz file
	@mkdir -p $(CDS3_TSCDALIAPPCONNECTOR_PKGDIR) && \
  tar xvzf $(CDS3_TSCDALIAPPCONNECTOR_PLATFORMCONFIGPACKAGEDIR)/$(CDS3_TSCDALIAPPCONNECTOR_PACKAGE_NAME).tgz -C $(CDS3_TSCDALIAPPCONNECTOR_PKGDIR)
else	
# 	normal mode, call "make install"	
	
	@$(call world/install, CDS3_TSCDALIAPPCONNECTOR)
	
ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_RELEASE
#   # save install directory to tgz for BSP mode
	@mkdir -p $(CDS3_TSCDALIAPPCONNECTOR_PLATFORMCONFIGPACKAGEDIR)
	@cd $(CDS3_TSCDALIAPPCONNECTOR_PKGDIR) && tar cvzf $(CDS3_TSCDALIAPPCONNECTOR_PLATFORMCONFIGPACKAGEDIR)/$(CDS3_TSCDALIAPPCONNECTOR_PACKAGE_NAME).tgz *
endif
endif
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-tscdaliappconnector.targetinstall:
	@$(call targetinfo)

	@$(call install_init, cds3-tscdaliappconnector)
	@$(call install_fixup, cds3-tscdaliappconnector,PRIORITY,optional)
	@$(call install_fixup, cds3-tscdaliappconnector,SECTION,base)
	@$(call install_fixup, cds3-tscdaliappconnector,AUTHOR,"Philipp Hundsdörfer")
	@$(call install_fixup, cds3-tscdaliappconnector,DESCRIPTION,missing)

#
# TODO: Add here all files that should be copied to the target
# Note: Add everything before(!) call to macro install_finish
#
	@$(call install_lib, cds3-tscdaliappconnector, 0, 0, 0644, libTscDALIAppConnector)
	@$(call install_link, cds3-tscdaliappconnector, ../$(CDS3_TSCDALIAPPCONNECTOR_BIN), /usr/lib/cds3-custom-components/libTscDALIAppConnector.so)

	@$(call install_finish, cds3-tscdaliappconnector)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-tscdaliappconnector.clean:
	@$(call targetinfo)
	@if [ -d $(CDS3_TSCDALIAPPCONNECTOR_DIR) ]; then \
	  $(CDS3_TSCDALIAPPCONNECTOR_MAKE_ENV) $(CDS3_TSCDALIAPPCONNECTOR_PATH) $(MAKE) $(MFLAGS) -C $(CDS3_TSCDALIAPPCONNECTOR_DIR) clean; \
	fi
	@$(call clean_pkg, CDS3_TSCDALIAPPCONNECTOR)
	@rm -rf $(CDS3_TSCDALIAPPCONNECTOR_BUILDROOT_DIR)

# vim: syntax=make
