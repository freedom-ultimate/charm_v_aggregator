#!/usr/bin/perl

use strict;
use warnings;

# Generate forward declarations for all types of control point effects.
# each one takes a name and an association (arrayProxy and/or entryID).
# use C++ to overload the function names.

open(OUT_H, ">cp_effects.h");
open(OUT_CPP, ">cp_effects.C");
open(FILE, "cp_effects.txt");

my $funcdecls;
my $funccalls;
my $funcdefs;

while(my $line = <FILE>) {
  chomp $line;

  if(length($line) > 0) {
    my $cp = $line;

    $funcdecls .= "\tvoid $cp(std::string name, const ControlPoint::ControlPointAssociation &a);\n";
    $funcdecls .= "\tvoid $cp(std::string name);\n";

    $funccalls .= "\tControlPoint::EffectIncrease::$cp(\"name\");\n";
    $funccalls .= "\tControlPoint::EffectDecrease::$cp(\"name\");\n";
    $funccalls .= "\tControlPoint::EffectIncrease::$cp(\"name\", assocWithEntry(0));\n";
    $funccalls .= "\tControlPoint::EffectDecrease::$cp(\"name\", assocWithEntry(0));\n";
    #$funccalls .= "\tControlPoint::EffectIncrease::$cp(\"name\", assocWithArray(0));\n";
    #$funccalls .= "\tControlPoint::EffectDecrease::$cp(\"name\", assocWithArray(0));\n";

    $funcdefs .= "void ControlPoint::EffectDecrease::$cp(std::string s, const ControlPoint::ControlPointAssociation &a) {\n" .
	"\tinsert(\"$cp\", s, a, EFF_DEC);\n" .
	"}\n";
    $funcdefs .= "void ControlPoint::EffectIncrease::$cp(std::string s, const ControlPoint::ControlPointAssociation &a) {\n" .
	"\tinsert(\"$cp\", s, a, EFF_INC);\n" .
	"}\n";
    $funcdefs .= "void ControlPoint::EffectDecrease::$cp(std::string s) {\n" .
	"\tinsert(\"$cp\", s, default_assoc, EFF_DEC);\n" .
	"}\n";
    $funcdefs .= "void ControlPoint::EffectIncrease::$cp(std::string s) {\n" .
	"\tinsert(\"$cp\", s, default_assoc, EFF_INC);\n" .
	"}\n";
  }
}

print OUT_H <<EOF;
#include <string>
#include <vector>
#include <set>
#include <map>
#include <utility>
#include <charm++.h>
#include <ck.h>
#include <ckarray.h>

///////////////////////////////////////////////////////////////////
// WARNING: THIS FILE IS GENERATED BY cp_effects.pl
//          ANY CHANGES TO THIS FILE MAY BE LOST 
///////////////////////////////////////////////////////////////////


#ifndef __CP_EFFECTS_H__
#define __CP_EFFECTS_H__

#if CMK_WITH_CONTROLPOINT

namespace ControlPoint {

  enum DIRECTION {EFF_DEC, EFF_INC};

  class ControlPointAssociation {
  public:
    std::set<int> EntryID;
    std::set<int> ArrayGroupIdx;
      ControlPointAssociation() {
	// nothing here yet
      }
  };
  
  class ControlPointAssociatedEntry : public ControlPointAssociation {
    public :
	ControlPointAssociatedEntry() : ControlPointAssociation() {}

	ControlPointAssociatedEntry(int epid) : ControlPointAssociation() {
	  EntryID.insert(epid);
	}    
  };
  
  class ControlPointAssociatedArray : public ControlPointAssociation {
  public:
    ControlPointAssociatedArray() : ControlPointAssociation() {}

    ControlPointAssociatedArray(const CProxy_ArrayBase &a) : ControlPointAssociation() {
      CkGroupID aid = a.ckGetArrayID();
      int groupIdx = aid.idx;
      ArrayGroupIdx.insert(groupIdx);
    }
  };
  
  class NoControlPointAssociation : public ControlPointAssociation { };


  void initControlPointEffects();
  ControlPointAssociatedEntry assocWithEntry(const int entry);
  ControlPointAssociatedArray assocWithArray(const CProxy_ArrayBase &array);

 //                 effect               cp                 direction           associations
  typedef std::map<std::string,std::map<std::string, std::pair<int, std::vector<ControlPoint::ControlPointAssociation> > > > cp_effect_map;

 //                   cp                          direction           associations
 //  typedef std::map<std::string, std::vector<std::pair<int, ControlPoint::ControlPointAssociation> > > cp_name_map;


namespace EffectIncrease {
$funcdecls
}

namespace EffectDecrease {
$funcdecls
}


} //namespace ControlPoint

CkpvExtern(ControlPoint::cp_effect_map, cp_effects);
//CkpvExtern(ControlPoint::cp_name_map, cp_names);

#endif
#endif
EOF


print OUT_CPP <<EOF;
///////////////////////////////////////////////////////////////////
// WARNING: THIS FILE IS GENERATED BY cp_effects.pl
//          ANY CHANGES TO THIS FILE MAY BE LOST 
///////////////////////////////////////////////////////////////////

#include "cp_effects.h"

#if CMK_WITH_CONTROLPOINT

using namespace ControlPoint;
using namespace std;

CkpvDeclare(ControlPoint::cp_effect_map, cp_effects);
//CkpvDeclare(ControlPoint::cp_name_map, cp_names);

NoControlPointAssociation default_assoc;

ControlPoint::ControlPointAssociatedEntry ControlPoint::assocWithEntry(const int entry) {
    ControlPointAssociatedEntry e(entry);
    return e;
}

ControlPoint::ControlPointAssociatedArray ControlPoint::assocWithArray(const CProxy_ArrayBase &array) {
    ControlPointAssociatedArray a(array);
    return a;
}

void ControlPoint::initControlPointEffects() {
    CkpvInitialize(cp_effect_map, cp_effects);
//    CkpvInitialize(cp_name_map, cp_names);
}

void testControlPointEffects() {
$funccalls
}

void insert(const std::string effect, const std::string name, const ControlPoint::ControlPointAssociation &assoc, const int direction) {
   std::pair<int, std::vector<ControlPoint::ControlPointAssociation> > &info = CkpvAccess(cp_effects)[effect][name];
   info.first = direction;
   info.second.push_back(assoc);
  // CkpvAccess(cp_names)[name] = make_pair(push_back(std::make_pair(direction, assoc));
}

$funcdefs

#endif
EOF
