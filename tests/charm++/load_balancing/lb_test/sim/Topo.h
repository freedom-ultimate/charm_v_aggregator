#ifndef TOPO_H
#define TOPO_H

#include "Topo.decl.h"

enum { N_BYTES=1000};

class TopoInitMsg : public CMessage_TopoInitMsg {
public:
  int elements;
  int topology;
  int seed;
  int min_us;
  int max_us;
};

enum TopoType { TopoRing, TopoMesh2D, TopoRandGraph, TopoError=-1 };
static const struct { 
  const char* name;
  const char* desc;
  TopoType id;
} TopoTable[] = {
  { "Ring",
    "ring - use ring topology",
    TopoRing },
  { "Mesh2D", 
    "mesh2d - construct a 2D mesh, with holes", 
    TopoMesh2D },
  { "RandGraph", 
    "randgraph - construct a graph, with 25% of links used",
    TopoRandGraph },
  { "", "", TopoError }
};


class Topo : public CBase_Topo {
public:
  struct MsgInfo {
    int obj;
    int bytes;
  };

  Topo(TopoInitMsg*);
  double Work(int indx) { return elemlist[indx].work; };
  static Topo* Create(const int _elem, const char*_topo, 
		    const int meanms, const int devms);
  int SendCount(int index);
  void SendTo(int index, MsgInfo* who);
  int RecvCount(int index);
  void RecvFrom(int index, MsgInfo* who);

private:
  struct Elem;
  friend struct Elem;  // Apparently, a private struct can't access another
                       // private struct without this!

  static int Select(const char*);
  void FindComputeTimes();
  void ConstructRing();
  void ConstructMesh2D();
  void ConstructRandGraph();
  float gasdev();

  struct Elem {
    double work;
    int receiving;
    int sending;
    MsgInfo* receivefrom;
    MsgInfo* sendto;
  };

  TopoType topo;
  int elements;
  Elem* elemlist;
  int seed;
  int min_us;
  int max_us;
};

#endif
