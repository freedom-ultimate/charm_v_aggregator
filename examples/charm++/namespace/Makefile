-include ../../common.mk
CHARMC = ../../../bin/charmc
BINARY = inherit

CHARMCFLAGS =
CHARMCLINKFLAGS = -language charm++
TESTFLAGS =

%.o: %.C

all: $(BINARY)
$(BINARY): $(patsubst %.C,%.o,$(wildcard *.C))
	$(CHARMC) $(CHARMCLINKFLAGS) -o $@ $+

C.o: B.decl.h B.def.h A.decl.h A.def.h
B.o: A.decl.h A.def.h

%.o: %.C %.decl.h %.def.h
	$(CHARMC) $(CHARMCFLAGS) $<

%.decl.h %.def.h: %.ci
	$(CHARMC) $(CHARMCFLAGS) $<

test: $(BINARY)
	$(call run, ./$(BINARY) $(TESTFLAGS))

clean:
	rm -f *.o *.decl.h *.def.h charmrun $(BINARY)
