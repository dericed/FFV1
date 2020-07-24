ifeq ($(shell curl --version >/dev/null 2>&1 || echo FAIL),)
download = curl -f -L -- "$(1)" > "$@.tmp" && touch $@.tmp && mv $@.tmp $@
else ifeq ($(shell wget --version >/dev/null 2>&1 || echo FAIL),)
download = rm -f $@.tmp && \
	wget --passive -c -p -O $@.tmp "$(1)" && \
	touch $@.tmp && \
	mv $@.tmp $@
else ifeq ($(which fetch >/dev/null 2>&1 || echo FAIL),)
download = rm -f $@.tmp && \
	fetch -p -o $@.tmp "$(1)" && \
	touch $@.tmp && \
	mv $@.tmp $@
else
download = $(error Neither curl nor wget found!)
endif

# mmark
mmark_$(MMARK_VERSION)_$(MMARK_OS)_$(MMARK_MACHINE).tgz:
	$(call download,https://github.com/mmarkdown/mmark/releases/download/v$(MMARK_VERSION)/mmark_$(MMARK_VERSION)_$(MMARK_OS)_$(MMARK_MACHINE).tgz)

mmark: mmark_$(MMARK_VERSION)_$(MMARK_OS)_$(MMARK_MACHINE).tgz
	tar xvzf $^
	touch $@

.buildmmark: mmark

.uninstall_mmark:
	$(RM) mmark

# xml2rfc
.buildxml2rfc:
	$(PIP_BIN) install --user "xml2rfc~=$(XML2RFC_VERSION)"

.uninstall_xml2rfc:
	$(PIP_BIN) uninstall -y xml2rfc

# xmlstarlet
xmlstarlet-$(XMLSTARLET_VERSION).tar.gz:
	$(call download,https://downloads.sourceforge.net/project/xmlstar/xmlstarlet/$(XMLSTARLET_VERSION)/xmlstarlet-$(XMLSTARLET_VERSION).tar.gz)

xmlstarlet: xmlstarlet-$(XMLSTARLET_VERSION).tar.gz
	tar xvzf $^
	touch $@

.buildxmlstarlet: xmlstarlet

.uninstall_xmlstarlet:
	$(RM) xmlstarlet


#XMLSTARLET_VERSION=$XMLSTARLET_VERSION
#PDFCROP_VERSION=$PDFCROP_VERSION
#PDF2SVG_VERSION=$PDF2SVG_VERSION

clean: .uninstall_mmark .uninstall_xml2rfc
