# defines
CXX=g++
CXXFLAGS= -O3 -Wall 

TARGET = graph_tools.o

all: $(TARGET)

.cpp.o:
	$(CXX) $(CXXFLAGS) -o $@ -c $<

clean:
	rm -rf *.o $(TARGET)

