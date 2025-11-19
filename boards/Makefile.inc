UNAME := $(shell uname)
XILINXENV:=
SRCROOT:=$(abspath $(PWD)/../../)
BRDROOT:=$(subst $(SRCROOT),,$(abspath $(PWD)))
DOCKERIMAGE:=terriblefire78/xilinx:v1

ifneq ($(UNAME), Linux)
      XILINXENV=docker run --rm --platform linux/amd64 -v $(SRCROOT):/host -w /host/$(BRDROOT) $(DOCKERIMAGE)
endif
