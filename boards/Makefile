PROJECT:=msxcart
BOARDS:=$(PROJECT)r1
GITVERSION:=`git rev-parse --short HEAD`
DATESTRING:=`date +"%Y_%m_%d"`
GITREPO:=$(shell basename `git rev-parse --show-toplevel`)
RELEASE_PACKAGE=$(GITREPO)_$(DATESTRING)_$(GITVERSION).zip

.PHONY: $(BOARDS)
all: clean
	rm -rf ./tf*_* ./msxcart_*
	mkdir -p ./$(PROJECT)_$(DATESTRING)_$(GITVERSION)
	@- $(foreach BOARD,$(BOARDS), cd $(BOARDS) ; make ; \
	cp *.jed ../$(PROJECT)_$(DATESTRING)_$(GITVERSION);)
	zip $(RELEASE_PACKAGE) ./$(PROJECT)_$(DATESTRING)_$(GITVERSION)/*
	rm -rf $(PROJECT)_$(DATESTRING)_$(GITVERSION)
clean:
	@- $(foreach BOARD,$(BOARDS), make -C $(BOARD) clean;)
	$(RM) *.zip
distclean:
	@- $(foreach BOARD,$(BOARDS), make -C $(BOARD) distclean;)
