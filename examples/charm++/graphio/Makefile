-include ../../config.mk
CHARMC = ../../../bin/charmc
OPTS= -std=c++11

TARGETS= test

all: $(TARGETS)

#--------------------------------------------------------------------
test: test.o
	$(CHARMC) $(OPTS) -language charm++ -o test $< -module graphio 

test.o: test.C test.decl.h
	$(CHARMC) -c test.C

test.decl.h: test.ci
	$(CHARMC) test.ci
#--------------------------------------------------------------------

clean:
	rm -f *.decl.h *.def.h conv-host *.o *.a charmrun *.log *.sum *.sts 
	rm -f $(TARGETS)
