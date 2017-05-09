CDIR=../../../..
CHARMC=$(CDIR)/bin/charmc $(OPTS)

MODULE=graphio
LIB = $(CDIR)/lib/libmodule$(MODULE).a
LIBOBJ = graphio.o

GENHEADERS = $(MODULE).decl.h $(MODULE).def.h
HEADERS = graphio.h $(GENHEADERS) GraphDistr.h GraphGenerator.h GraphFileIO.h GraphIO.h
GENDEPENDS = GraphHPC-1.0/graph_tools.o
DEPENDS = GraphHPC-1.0

all: $(LIB)

$(LIB): $(GENDEPENDS) $(GENHEADERS) $(LIBOBJ)
	$(CHARMC) -o $(LIB) $(LIBOBJ) $(GENDEPENDS)
	cp $(HEADERS) $(CDIR)/include/
	cp -r $(DEPENDS) $(CDIR)/include/

graphio.o: graphio.C
	$(CHARMC) -c $<

$(GENHEADERS): graphio.ci
	$(CHARMC) $<

$(GENDEPENDS): GraphHPC-1.0
	make -C $(DEPENDS) all

clean:
	rm -f *.o *.decl.h *.def.h $(LIB)
	make -C $(DEPENDS) clean
