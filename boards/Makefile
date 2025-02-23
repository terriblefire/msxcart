PROJECT:=msxcart
BOARDS:=$(PROJECT)r1
.PHONY: $(BOARDS)
FOLDER:=$(PROJECT)_`date +"%Y_%m_%d"`
all: clean
	rm -rf ./tf*_*
	mkdir ./$(FOLDER)
	@- $(foreach BOARD,$(BOARDS), cd $(BOARDS) ; make ; \
	cp *.jed ../$(FOLDER);)
	zip $(FOLDER).zip ./$(FOLDER)/*
	rm -rf $(FOLDER)
clean: 
	@- $(foreach BOARD,$(BOARDS), make -C $(BOARD) clean;)
distclean: 
	@- $(foreach BOARD,$(BOARDS), make -C $(BOARD) distclean;)
