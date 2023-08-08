encapsulated package NMBDAEDump
"
Desc: Contains all functions to print the complete ImportDAE and BackendDAE structure as constructor calls. The output will be a string of nested constructors. Arrays have to be printed as lists in the form {...}. Other list constructors like list(..) will not work.
"
protected
import NMBDAE;

public

function dumpAdjacencyMatrix
"
Desc: Dump DAE.AdjacencyMatrix as {{..},{..},..,{..}}
"
  input NMBDAE.AdjacencyMatrix inAdjMat;
  output String s;
protected
  Integer dim;
algorithm 
  dim := arrayLength(inAdjMat);
  s := "{";
  for i in 1:dim-1 loop
    s := s + "{" + Listdump(inAdjMat[i],intString) + "},";
  end for;
  if(0 < dim) then
    s := s + "{" + Listdump(inAdjMat[dim],intString) + "}";
  end if;
  s := s + "}";
end dumpAdjacencyMatrix;

function dumpBackendDAE
"
Desc: Dump DAE.BackendDAE as DAE.BACKENDDAE(...)
"
  input NMBDAE.BackendDAE inDae;
  output String s = "";
  protected
  algorithm
    s := "DAE.BACKENDDAE("
      + dumpEquationSystem(inDae.simulation) + "," 
      + dumpEquationSystem(inDae.initialization) + ","
      + dumpShared(inDae.shared);
    s := s + ")";
end dumpBackendDAE;
  
function dumpEquationSystem
"
Desc: Dump DAE.EquationSystem as DAE.EQUATION_SYSTEM(...)
"
  input NMBDAE.EquationSystem inEquSystem;
  output String s = "";
  protected
    String s1;
  algorithm
    s := "DAE.EQUATION_SYSTEM("
      + dumpVariableArray(inEquSystem.variables) + "," 
      + dumpEquationArray(inEquSystem.equations) + ",";
    s1 := match(inEquSystem.adjacency)
      local
        NMBDAE.AdjacencyMatrix lm;
      case(SOME(lm)) then "SOME(" + dumpAdjacencyMatrix(lm) + ")";
      case NONE() then "NONE()";
    end match;
    s := s + s1 + ",";
    s1 := match(inEquSystem.adjacencyTranspose)
      local
        NMBDAE.AdjacencyMatrix lm;
      case(SOME(lm)) then "SOME(" + dumpAdjacencyMatrix(lm) + ")";
      case NONE() then "NONE()";
    end match;
    s := s + s1 + ",";
    s1 := match(inEquSystem.matching)
      local
        NMBDAE.Matching lm;
      case(SOME(lm)) then "SOME(" + dumpMatching(lm) + ")";
      case NONE() then "NONE()";
    end match;
    s := s + s1 + ","; 
    s := s + dumpStrongComponents(inEquSystem.strongComponents);      
    s := s + ")"; 
end dumpEquationSystem;  

function dumpShared
"
Desc: Dump DAE.Shared as DAE.SHARED(...)
"
  input NMBDAE.Shared inShared;
  output String s = "";
  protected
  algorithm
    s := "DAE.SHARED("
      + dumpVariableArray(inShared.parameterVariables) + "," 
      + dumpVariableArray(inShared.stateVariables) + ","
      + dumpVariableArray(inShared.aliasVariables) + ","
      + dumpEquationSystem(inShared.removedEqns) + ","
      + dumpExtraInfo(inShared.info);
    s := s + ")"; 
end dumpShared;  


function dumpComponentRef
"
Desc: Dump DAE.ComponentRef as DAE.COMPONENT_REF(...)
"
  input NMBDAE.ComponentRef cref;
  output String s;
  protected
    String s1;
  algorithm
  s :="DAE.COMPONENT_REF(";
  s := s + "\"" + cref.name + "\",";
  s1 := match(cref.qualName)
      local NMBDAE.ComponentRef lcref;
    case SOME(lcref) then "SOME(" + dumpComponentRef(lcref) + ")";
    case NONE() then "NONE()";
    end match;
  s := s + s1 + ")";
end dumpComponentRef; 

function dumpCrefIndex
"
Desc: Dump DAE.CrefIndex as DAE.CREF_INDEX(...)
"
  input NMBDAE.CrefIndex inCrefIdx;
  output String s = "";
  algorithm
    s := "DAE.CREF_INDEX("
      + dumpComponentRef(inCrefIdx.cref) + ","
      + String(inCrefIdx.index) + ")";
end dumpCrefIndex;
 
function dumpDirection
"
Desc: Dump DAE.Direction as DAE.INPUT()
or as DAE.OUTPUT()
or as DAE.NODIR()
"
  input NMBDAE.Direction dir;
  output String s;
  protected
  algorithm
  s := match(dir)
  case (NMBDAE.INPUT()) then "DAE.INPUT()";
  case (NMBDAE.OUTPUT()) then "DAE.OUTPUT()";
  case (NMBDAE.NODIR()) then "DAE.NODIR()";
  end match;
end dumpDirection;

function dumpEquation
"
Desc: Dump DAE.Equation as DAE.EQUATION(...)
"
  input NMBDAE.Equation equ;
  output String str;
  algorithm
  str := "DAE.EQUATION(" + dumpExp(equ.lhs) + "," + dumpExp(equ.rhs) + ")";
end dumpEquation;

function dumpEquationArray
"
Desc: DAE.EquationArray as DAE.EQUATION_ARRAY(...)
"
  input NMBDAE.EquationArray inEqnArr;
  output String s = "";
  protected
    Integer dim;  // Arraydimension
  algorithm
    dim := inEqnArr.size;
    s := "DAE.EQUATION_ARRAY(";
    s := s + String(inEqnArr.size) + ",";    
    s := s + "{";  
    for i in 1:dim-1 loop
      s := s + dumpEquation(inEqnArr.equations[i]) + ",";
    end for;
    if(0 < dim) then
      s := s + dumpEquation(inEqnArr.equations[dim]);       
    end if;
    s := s + "})";
end dumpEquationArray;

function dumpExp
"
Desc: Dump DAE.Exp as DAE.INT(...)
or as DAE.REAL(...)
or as DAE.BOOL(...)
or as DAE.CREF(...)
or as DAE.STRING(...)
or as DAE.BINARY(...)
or as DAE.UNARY(...)
or as DAE.CALL(...)
"
  input NMBDAE.Exp inExp;
  output String result;
algorithm
  result := match(inExp)
    local
      String s1, s2="", sop="";
      Integer i;
      Real r;
      Boolean b;
      NMBDAE.Exp exp1, exp2;
      list<NMBDAE.Exp> expList;
      NMBDAE.BinOp bop;
      NMBDAE.UnOp uop;
      NMBDAE.ComponentRef c1;

	  case(NMBDAE.CALL(id=s1, args=expList))
	  //then "DAE.CALL(\"" + s1 + "\",{" + dumpExpList(expList) + "})";
    then "DAE.CALL(\"" + s1 + "\",{" + Listdump(expList,dumpExp) + "})";

    case(NMBDAE.INT(integer=i))
    then "DAE.INT(" + intString(i) + ")";

    case(NMBDAE.REAL(real=r))
    then "DAE.REAL(" + realString(r) + ")";

    case(NMBDAE.BOOL(bool=b))
    then "DAE.BOOL(" + boolString(b) + ")";

    case(NMBDAE.STRING(string=s1))
    then "DAE.STRING(\"" + s1 + "\")";

    case(NMBDAE.CREF(id=c1))
    then "DAE.CREF(" + dumpComponentRef(c1) + ")";

    case (NMBDAE.BINARY(exp1=exp1, op=bop, exp2=exp2))
      equation
        s1 = dumpExp(exp1);
        s2 = dumpExp(exp2);
        sop = dumpBinOp(bop);
      then "DAE.BINARY(" + s1 + "," + sop + "," + s2 + ")"; 

    case (NMBDAE.UNARY(uop, exp1))
      equation
        s1 = dumpExp(exp1);
        sop = dumpUnOp(uop);
    then "DAE.UNARY(" + sop + "," + s1 + ")";	  

    else equation
      print("Something else failed\n");
    then fail();
  end match;
end dumpExp;

function dumpBinOp
"
Desc: Dump DAE.BinOp as DAE.BinOp(...)
"
  input NMBDAE.BinOp inBinOp;
  output String s;
  algorithm    
    s := match(inBinOp)
    case(NMBDAE.SUB())	then "DAE.SUB()";
    case(NMBDAE.ADD())	then "DAE.ADD()";
    case(NMBDAE.MUL())	then "DAE.MUL()";
    case(NMBDAE.DIV())	then "DAE.DIV()";
    case(NMBDAE.POW())	then "DAE.POW()";
    else fail();
    end match;
end dumpBinOp;  
     
function dumpUnOp
"
Desc: Dump DAE.UnOp as DAE.UnOp(...)
"
  input NMBDAE.UnOp inUnOp;
  output String s;
  algorithm    
    s := match(inUnOp)
    case(NMBDAE.NEG())	then "DAE.NEG()";
    else fail();
    end match;
end dumpUnOp;
       
function dumpImportDAE
"
Desc: Dump DAE.ImportDAE as DAE.IMPORT_DAE(...)
"
  input NMBDAE.ImportDAE inImpDae;
  output String s;
  algorithm
  s := "
package Data
  import DAE;
   
  function getModel
    output DAE.ImportDAE data;
  algorithm

      data := ";
  s := s + "DAE.IMPORT_DAE({" 
  + Listdump(inImpDae.variables,dumpVariable) + "}" 
  + ",\n\n{" + Listdump(inImpDae.equations,dumpEquation) + "}" 
  + ",\n\n{" + Listdump(inImpDae.initialEquations,dumpEquation) + "}" 
  + ",\n\n{" + Listdump(inImpDae.bindingEquations,dumpEquation) + "}" 
  + ",\n\n" + dumpExtraInfo(inImpDae.info) + "\n"
  + ")";
  
  s := s + ";
  end getModel;
  end Data;";
end dumpImportDAE;

function dumpKind
"
Desc: Dump DAE.Kind() as DAE.K_VARIABLE()
or as DAE.K_STATE()
or as DAE.K_DER_STATE()
or as DAE.K_PARAMETER()
or as DAE.K_CONSTANT()
"
  input NMBDAE.Kind kind;
  output String s;
  protected
  algorithm
  s := match(kind)
  case (NMBDAE.K_VARIABLE()) then "DAE.K_VARIABLE()";
  case (NMBDAE.K_STATE()) then "DAE.K_STATE()";
  case (NMBDAE.K_DER_STATE()) then "DAE.K_DER_STATE()";
  case (NMBDAE.K_PARAMETER()) then "DAE.K_PARAMETER()";
  case (NMBDAE.K_CONSTANT()) then "DAE.K_CONSTANT()";
  case (NMBDAE.K_DUMMY_STATE()) then "DAE.K_DUMMY_STATE()";
  case (NMBDAE.K_DUMMY_DER()) then "DAE.K_DUMMY_DER()";
  end match;
end dumpKind;

function dumpMatching
"
Desc: Dump DAE.Matching as DAE.MATCHING(...)
"
  input NMBDAE.Matching inMatch;
  output String s = "";
  protected
    Integer dim;
  algorithm
    dim := arrayLength(inMatch.variableAssign);
    s := "DAE.MATCHING(";
    s := s + "{";  
    for i in 1:dim-1 loop
      s := s + String(inMatch.variableAssign[i]) + ",";
    end for;
    if(0 < dim) then
      s := s + String(inMatch.variableAssign[dim]);
    end if;
    s := s + "},";
    
    dim := arrayLength(inMatch.equationAssign);
    s := s + "{";  
    for i in 1:dim-1 loop
      s := s + String(inMatch.equationAssign[i]) + ",";
    end for;
    if(0 < dim) then
      s := s + String(inMatch.equationAssign[dim]);
    end if;   
    s := s + "})";
end dumpMatching;

function dumpStrongComponent
"
Desc: Dump DAE.StrongComponent as DAE.SINGLE_EQUATION(...)
or as DAE.EQUATION_SYSTEM(...)
"
  input NMBDAE.StrongComponent inStrComp;
  output String s = "";
protected
  String s1;
algorithm
  s1 := match(inStrComp)
    local 
      String s2 = "";
      String s3 = "";
      Integer i1, i2;
      list<Integer> Li1, Li2;
      Option<NMBDAE.Exp> oe1, oe2;
      NMBDAE.Exp e1, e2;
      list<NMBDAE.Exp> lexp1;
      list<list<NMBDAE.Exp>> lexp2;      
    case(NMBDAE.SINGLE_EQUATION(equationIndex=i1,variableIndex=i2,residual=oe1, derivative=oe2))
    algorithm
      s2 := match(oe1)
      case SOME(e1) then dumpExp(e1);
      else "NONE()";
      end match;
      s3 := match(oe2)
      case SOME(e2) then dumpExp(e2);
      else "NONE()";
      end match;
    then "DAE.SINGLE_EQUATION(" + String(i1) + "," + String(i2) + "," + s2 + "," + s3 + ")";
    case(NMBDAE.ALGEBRAIC_LOOP(equationIndices=Li1,variableIndices=Li2, residuals=lexp1, jacobian=lexp2))
    algorithm
      s2 := "";
      for le in lexp2 loop
        s2 := s2 + "{" + Listdump(le,dumpExp) + "},";
      end for;
      // remove last comma from string s2
      s2 := substring(s2,1,stringLength(s2)-1);
    then "DAE.ALGEBRAIC_LOOP({" + Listdump(Li1,intString) + "},{" 
          + Listdump(Li2,intString) + "},{" + Listdump(lexp1,dumpExp) + "},{" + s2 + "})";
  end match;
  s := s + s1;
end dumpStrongComponent;

function dumpStrongComponents
"
Desc: Dump DAE.StrongComponents as {...}
"
  input NMBDAE.StrongComponents inStrComps;
  output String s = "";
  algorithm
  s := "{"
    + Listdump(inStrComps,dumpStrongComponent) + "}";
end dumpStrongComponents;

function dumpType
"
Desc: Dump DAE.Type as DAE.T_REAL()
or as DAE.T_INTEGER()
or as DAE.T_BOOL()
or as DAE.T_STRING()
"
  input NMBDAE.Type tp;
  output String s;
  protected
  algorithm
  s := match(tp)
  case (NMBDAE.T_REAL()) then "DAE.T_REAL()";
  case (NMBDAE.T_INTEGER()) then "DAE.T_INTEGER()";
  case (NMBDAE.T_BOOL()) then "DAE.T_BOOL()";
  case (NMBDAE.T_STRING()) then "DAE.T_STRING()";
  end match;
end dumpType;

function dumpVarAttributes
"
Desc: Dump DAE.VarAttributes as DAE.VAR_ATTRIBUTES(...)
"
  input NMBDAE.VarAttributes attr;
  output String s;
  protected
    String s1;
  algorithm
  s :="DAE.VAR_ATTRIBUTES(";  
  s1 := match(attr.start)
      local NMBDAE.Exp exp;
    case SOME(exp) then "SOME(" + dumpExp(exp) + ")";
    case NONE() then "NONE()";
    end match;
  s := s + s1;
  
  s1 := match(attr.fixed)
      local NMBDAE.Exp exp;
    case SOME(exp) then "SOME(" + dumpExp(exp) + ")";
    case NONE() then "NONE()";
    end match;
  s := s + "," + s1;  
  s1 := match(attr.min)
      local NMBDAE.Exp exp;
    case SOME(exp) then "SOME(" + dumpExp(exp) + ")";
    case NONE() then "NONE()";
    end match;
  s := s + "," + s1;
  s1 := match(attr.max)
      local NMBDAE.Exp exp;
    case SOME(exp) then "SOME(" + dumpExp(exp) + ")";
    case NONE() then "NONE()";
    end match;
  s := s + "," + s1;
  s1 := match(attr.nominal)
      local NMBDAE.Exp exp;
    case SOME(exp) then "SOME(" + dumpExp(exp) + ")";
    case NONE() then "NONE()";
    end match;
  s := s + "," + s1;
  s1 := match(attr.unit)
      local NMBDAE.Exp exp;
    case SOME(exp) then "SOME(" + dumpExp(exp) + ")";
    case NONE() then "NONE()";
    end match;
  s := s + "," + s1;  
  s := s + ")";
end dumpVarAttributes;

function dumpVariable
"
Desc: Dump DAE.Variable as DAE.VARIABLE(...)
"
  input NMBDAE.Variable var;
  output String str;
  protected
    String s1, s2;
  algorithm
  str := "";
  s2 := "";
  s1 := "DAE.VARIABLE(";
  s1 := s1 + dumpComponentRef(var.name) + ",";
  s1 := s1 + dumpType(var.tp) + ",";
  s1 := s1 + dumpKind(var.kind) + ",";
  s1 := s1 + dumpDirection(var.direction) + ",";
  s2 := match(var.bindExp)
  local
    NMBDAE.Exp lexp;
  case(SOME(lexp)) then "SOME(" + dumpExp(lexp) + ")";
  case NONE() then "NONE()";
  end match;
  s1 := s1 + s2 + ",";
  s2 := match(var.attributes)
  local
    NMBDAE.VarAttributes lattr;
  case(SOME(lattr)) then "SOME(" + dumpVarAttributes(lattr) + ")";
  case NONE() then "NONE()";
  end match;
  s1 := s1 + s2 + ",";  
  str := s1 + "\"" + var.comment + "\")";
end dumpVariable;

function dumpVariableArray
"
Desc: Dump DAE.VariableArray as DAE.VARIABLE_ARRAY(...)
"
  input NMBDAE.VariableArray inVarArr;
  output String s = "";
  protected
    Integer dim;
  algorithm
  dim := inVarArr.size;
  s := "DAE.VARIABLE_ARRAY(";
  s := s + String(inVarArr.size) + ",";
  s := s + "{";  
  // Attention: Don't use "arrayLength" or "for v in inVarArr.variables loop", 
  // because the arrayLength is greater then the size and all unused elements 
  // are not initialized. So any access to such an element will result in a 
  // segmentation fault!
  for i in 1:dim-1 loop
    s := s + dumpVariable(inVarArr.variables[i]) + ",\n";
  end for;
  if(0 < dim) then
    s := s + dumpVariable(inVarArr.variables[dim]);  
  end if;
  s := s + "},";
 
  dim := arrayLength(inVarArr.variableIndices);
  s := s + "{";  
  for i in 1:dim-1 loop
    //if 0 <> listLength(inVarArr.variableIndices[i]) then
      s := s + "{" + Listdump(inVarArr.variableIndices[i],dumpCrefIndex) + "},";
    //end if;
  end for;
  if(0 < dim) then
    //if 0 <> listLength(inVarArr.variableIndices[dim]) then
      s := s + "{" + Listdump(inVarArr.variableIndices[dim],dumpCrefIndex);
    //end if;
    s := s + "}";
  end if;
  s := s + "})";
end dumpVariableArray;

function dumpExtraInfo
  input NMBDAE.ExtraInfo inInfo;
  output String s = "";
  protected
    String s1 = "";
    String s2 = "";
  algorithm
    s := "DAE.EXTRA_INFO(";
    NMBDAE.EXTRA_INFO(s1, s2) := inInfo;
    s := s + "\"" + s1 + "\", \"" + s2 + "\")";
end dumpExtraInfo;

protected
public function Listdump<T>
  "Takes a list and a function, and creates a new list as a String ...,...,... (without leading and trailing {} ) by applying the function to each element of the list."
  input list<T> inList;
  input MapFunc inFunc;
  output String s;

  partial function MapFunc
    input T inElement;
    output String s;
  end MapFunc;
  protected
    list<T> tail;
    T head;
algorithm
  s := match(inList)
  case {} 
		then "";
  case head::{}
    then inFunc(head);
  case head::tail
    then inFunc(head) + "," + Listdump(tail, inFunc);
  end match;  
end Listdump;

annotation(__OpenModelica_Interface="backend");
end NMBDAEDump;