encapsulated package AnalyzeModel


protected
import Absyn;
import DAE;
import FCore;
import FGraph;
import BackendDAE;
import BackendDump;
import ComponentReference;
import Dump;
import DAEDump;
import FGraphDump;
import DoubleEnded;
import ZeroCrossings;

public function analyze
  input BackendDAE.EqSystem syst;
  input BackendDAE.Variables globalKnownVars;
  input BackendDAE.Variables localKnownVars;
  input BackendDAE.Variables  extVars;
  input BackendDAE.Variables aliasVars;
  input BackendDAE.EquationArray ieqnarr;
  input list<DAE.Constraint> constrs;
  input list<DAE.ClassAttributes> clsAttrs;  
  input FCore.Cache inCache;
  input FCore.Graph inEnv;  
  input DAE.FunctionTree functionTree;
  input BackendDAE.EventInfo einfo;
  input BackendDAE.ExternalObjectClasses extObjCls;
  input BackendDAE.SymbolicJacobians symjacs;
  input BackendDAE.ExtraInfo inExtraInfo;
    
algorithm
    print("syst::{}\n"); // Equations, Variables
    BackendDump.dumpEqSystem(syst, "syst");    

    print("BackendDAE.SHARED(\n");
    print("globalKnownVars,\n"); // Parameter, Konstanten
    BackendDump.dumpVariables(globalKnownVars,"globalKnownVars");

    print("localKnownVars,\n");
    BackendDump.dumpVariables(localKnownVars,"localKnownVars");

    print("extVars,\n");
    BackendDump.dumpVariables(extVars,"extVars");

    print("aliasVars,\n");
    BackendDump.dumpVariables(aliasVars,"aliasVars");
    
    print("ieqnarr,\n"); // Initial Equations
    BackendDump.dumpEquationArray(ieqnarr,"ieqnarr");
    
    print("\nBackendEquation.emptyEqns(),\n");
    
    print("\nconstrs,\n");
    print("DAE.Constraints brauchen eine separate dump-Funktion\n");
    
    print("\nclsAttrs,\n");
    print("DAE.ClassAttributes brauchen eine separate dump-Funktion\n");
    
    print("\ninCache,\n");
    print("FCore.Cache brauchen eine separate dump-Funktion\n");
    
    
    print("\ninEnv,\n");
    print("\n" + inExtraInfo.fileNamePrefix + ".gml\n");
    FGraphDump.dumpGraph(inEnv, inExtraInfo.fileNamePrefix + ".gml");
    
    print("\nfunctionTree,\n");
    DAEDump.dumpFunctionTree(functionTree,"functionTree");
    print("\n einfo,\n");
    anaEventInfo(einfo);    
    print("\nextObjCls,\n");
    anaExternalObjectClasses(extObjCls);    
    print("\nBackendDAE.SIMULATION(),\n");
    print("\nsymjacs\n");
    anaSymbolicJacobians(symjacs);
    print("\ninExtraInfo,\n=================\n");
    anaExtraInfo(inExtraInfo);
    print("\nBackendDAEUtil.emptyPartitionsInfo(),\n");
    print("\nBackendDAE.emptyDAEModeData,\n");
    BackendDump.dumpBackendDAEModeData(BackendDAE.emptyDAEModeData);
    print("NONE(),\n");
    print("NONE()\n");  
end analyze;


function anaEventInfo
// uniontype EventInfo
  // record EVENT_INFO
    // list<TimeEvent> timeEvents         "stores all information related to time events";
    // ZeroCrossingSet zeroCrossings "list of zero crossing conditions";
    // DoubleEnded.MutableList<ZeroCrossing> relations    "list of zero crossing function as before";
    // ZeroCrossingSet samples       "[deprecated] list of sample as before, only used by cpp runtime (TODO: REMOVE ME)";
    // Integer numberMathEvents           "stores the number of math function that trigger events e.g. floor, ceil, integer, ...";
  // end EVENT_INFO;
// end EventInfo;
  input BackendDAE.EventInfo einfo;
protected
  list<BackendDAE.TimeEvent> timeEvents;
  BackendDAE.ZeroCrossingSet zeroCrossings;
  DoubleEnded.MutableList<BackendDAE.ZeroCrossing> relations;
  BackendDAE.ZeroCrossingSet samples;
  Integer nMathEvents;
algorithm
  BackendDAE.EVENT_INFO(timeEvents, zeroCrossings, relations, samples, nMathEvents) := einfo;
  print("\n\tTimeEvents\n");
  BackendDump.dumpTimeEvents(timeEvents,"TimeEvents");
  print("\n\tzeroCrossings\n");
  anaZeroCrossingSet(zeroCrossings);
  print("\n\trelations\n");
  BackendDump.dumpZeroCrossingList(DoubleEnded.toListNoCopyNoClear(relations),"List of zero crossing functions");
  print("\n\tsamples\n");
  anaZeroCrossingSet(samples);
  print("\nNumber MathEvents = " + String(nMathEvents) + "\n");
end anaEventInfo;


function anaZeroCrossingSet
// uniontype ZeroCrossingSet
  // record ZERO_CROSSING_SET
    // DoubleEnded.MutableList<ZeroCrossing> zc;
    // array<ZeroCrossings.Tree> tree;
  // end ZERO_CROSSING_SET;
// end ZeroCrossingSet;
  input BackendDAE.ZeroCrossingSet zCS;
protected
  DoubleEnded.MutableList<BackendDAE.ZeroCrossing> zc;
  array<ZeroCrossings.Tree> tree;
algorithm
  BackendDAE.ZERO_CROSSING_SET(zc, tree) := zCS;
  BackendDump.dumpZeroCrossingList(DoubleEnded.toListNoCopyNoClear(zc),"ZeroCrossings");
  // TODO: dump tree
end anaZeroCrossingSet;



function anaExternalObjectClasses
  input BackendDAE.ExternalObjectClasses extObj;
algorithm
  for obj in extObj loop
    anaExternalObjectClass(obj);
  end for;
end anaExternalObjectClasses;

function anaExternalObjectClass
// uniontype ExternalObjectClass "class of external objects"
  // record EXTOBJCLASS
    // Absyn.Path path "className of external object";
    // .DAE.ElementSource source "origin of equation";
  // end EXTOBJCLASS;
// end ExternalObjectClass;
  input BackendDAE.ExternalObjectClass extObj;
protected
  Absyn.Path path;
  DAE.ElementSource source;
algorithm
  BackendDAE.EXTOBJCLASS(path = path, source = source) := extObj;
  Dump.printPath(path);
end anaExternalObjectClass;


function anaSymbolicJacobians
// type SymbolicJacobians = list<tuple<Option<SymbolicJacobian>, SparsePattern, SparseColoring>>;
  input BackendDAE.SymbolicJacobians symjacs;
  protected
    Option<BackendDAE.SymbolicJacobian> o_symjac;
    BackendDAE.SymbolicJacobian symjac;
    BackendDAE.SparsePattern pattern;
    BackendDAE.SparseColoring coloring;
  algorithm
    for tup in symjacs loop
      (o_symjac, pattern, coloring) := tup;
      _ := match o_symjac
      case SOME(symjac)
      algorithm
        anaSymbolicJacobian(symjac);
        BackendDump.dumpSparsityPattern(pattern,"Pattern");
        BackendDump.dumpSparseColoring(coloring,"Coloring");
        then "";
      else 
      algorithm
        print("\nKeine SymbolicJacobians\n");
        then "";
      end match;
    end for;
end anaSymbolicJacobians;

function anaSymbolicJacobian
// type SymbolicJacobian = tuple<BackendDAE,    // symbolic equation system
//                              String,  // Matrix name
//                             list<Var>,  // diff vars (independent vars)
//                              list<Var>,  // diffed vars (residual vars)
//                              list<Var>,  // all diffed vars (residual vars + dependent vars)
//                              list< .DAE.ComponentRef>  // original dependent variables
//                              >;
  input BackendDAE.SymbolicJacobian symjac;
protected
  BackendDAE.BackendDAE bDAE;
  String name;
  list<BackendDAE.Var> diffVars, diffedVars, allDiffedVars;
  list<DAE.ComponentRef> dependendVars;
algorithm
  print("SymbolicJacobian\n==================\n");
  (bDAE, name, diffVars, diffedVars, allDiffedVars, dependendVars) := symjac;
  BackendDump.dumpBackendDAE(bDAE,"BackendDAE from SymbolicJacobian");
  print("\n" + name + "\n======================\n");
  BackendDump.dumpVarList(diffVars,"diffVars");
  BackendDump.dumpVarList(diffedVars,"diffedVars");
  BackendDump.dumpVarList(allDiffedVars,"allDiffedVars");
  print("\nOriginal dependend Variables\n=======================\n");
  for cref in dependendVars loop
    print(ComponentReference.printComponentRefStr(cref));
  end for;
  
end anaSymbolicJacobian;

function anaExtraInfo
// uniontype ExtraInfo "extra information that we should send around with the DAE"
  // record EXTRA_INFO
    // String description    "the model description string";
    // String fileNamePrefix "the model name to be used in the dumps";
  // end EXTRA_INFO;
// end ExtraInfo;
input BackendDAE.ExtraInfo inExtraInfo;
algorithm
  _ := match inExtraInfo
    local String s1, s2;
  case BackendDAE.EXTRA_INFO(s1, s2) 
    algorithm
      print("description: " + s1 + "\n");
      print("file name prefix:" + s2 + "\n");
  then "";
  else "";
  end match;
end anaExtraInfo;

annotation(__OpenModelica_Interface="backend");
end AnalyzeModel;