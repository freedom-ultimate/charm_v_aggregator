-include ../../../../config.mk
CHARMC = ../../../../../bin/charmc

BINARY = alltoall

all: $(BINARY)

alltoall: alltoall.o
	$(CHARMC) -language charm++ -o $@ $+
alltoall.o: alltoall.C alltoall.decl.h alltoall.def.h
	$(CHARMC) -language charm++ -c -o $@ $< 

%.def.h %.decl.h: %.ci
	$(CHARMC) $<

clean: 
	rm -f $(BINARY)
	rm -f *.decl.h *.def.h *.o charmrun 
