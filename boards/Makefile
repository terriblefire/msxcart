PROJECT:=tfmsx
BOARDS:=$(PROJECT)r0
.PHONY: $(BOARDS)
FOLDER:=tfmsx_`date +"%Y_%m_%d"`
all: clean
	rm -rf ./tf*_*
	mkdir ./$(FOLDER)
	@- $(foreach BOARD,$(BOARDS), make -C $(BOARD); \
	cp $(BOARD)/*.jed ./$(FOLDER);)
	zip $(FOLDER)_alpha.zip ./$(FOLDER)/*
	rm -rf $(FOLDER)
clean: 
	@- $(foreach BOARD,$(BOARDS), make -C $(BOARD) clean;)
distclean: 
	@- $(foreach BOARD,$(BOARDS), make -C $(BOARD) distclean;)
