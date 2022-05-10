encapsulated package NMBDAECreate

protected 
import Absyn;
import AbsynUtil;
import BackendDAE;
import BackendEquation;
import BackendVariable;
import BackendDump;
import ExpressionDump;
import NMBDAE;
import NMBDAEDump;

public function createDAE 
  "Create an ImportDAE object from the frontend data.
  
  The following inputs are used to create a standard BackendDAE. 
  Many of these objects are empty or not necessary for a NMBDAE."
  input BackendDAE.EqSystem syst "Main equation system";
  input BackendDAE.Variables globalKnownVars "Parameters and constants";
//  input BackendDAE.Variables localKnownVars;
//  input BackendDAE.Variables  extVars;
//  input BackendDAE.Variables aliasVars;
  input BackendDAE.EquationArray ieqnarr "Initial equations";
//  input list<DAE.Constraint> constrs "Optimica, Tearing";
//  input list<DAE.ClassAttributes> clsAttrs "Optimica";  
//  input FCore.Cache inCache;
//  input FCore.Graph inEnv;  
//  input DAE.FunctionTree functionTree "Dump zeigt functions des Modells an."; 
//  input BackendDAE.EventInfo einfo "";
//  input BackendDAE.ExternalObjectClasses extObjCls "";
//  input BackendDAE.SymbolicJacobians symjacs "";
  input BackendDAE.ExtraInfo inExtraInfo "2 strings model name and sth else";
  output NMBDAE.ImportDAE nmbImportDAE "Variables and equations used by the NMB.";
protected
  list<NMBDAE.Variable> nmbVariables = {};
  list<NMBDAE.Equation> nmbEquations = {};
  list<NMBDAE.Equation> nmbInitialEquations = {};
  list<NMBDAE.Equation> nmbBindingEquations = {};
  NMBDAE.ExtraInfo xinfo;
algorithm
  // Der Weg: Hole aus den Eingabedaten
  // 1. alle Variablen,
  print("Variablen\n");
  nmbVariables := translateVariables(syst, globalKnownVars);
  // 2. alle Gleichungen,
  print("Gleichungen\n");
  nmbEquations := translateEquations(syst);
  // 3. alle Anfangsgleichungen und
  print("Anfangsgleichungen\n");
  nmbInitialEquations := translateInitialEquations(ieqnarr);
  // 4. alle Bindungsgleichungen
  print("Bindungsgleichungen\n");
  nmbBindingEquations := translateBindingEquations(syst);
  // 5. extra Info
  print("ExtraInfo\n");
  xinfo := translateExtraInfo(inExtraInfo);
  // 6. stecke alles in die ImportDAE Struktur
  print("Komposition\n");
  nmbImportDAE := NMBDAE.IMPORT_DAE(nmbVariables, nmbEquations, nmbInitialEquations, nmbBindingEquations, xinfo);
end createDAE;

protected
function translateVariables
  "Searches for all variables in the model: states, parameters, constants,...
  "
  input BackendDAE.EqSystem syst "Equations and all unknown vars (states are not identified up to now)";
  input BackendDAE.Variables globalKnownVars "Parameters, constants and some other.";
  output list<NMBDAE.Variable> nmbVariables = {} "All variables in the hole model.";
protected
  BackendDAE.Variables vars;
  list<BackendDAE.Var> varLst;
algorithm
  // Variables & states
  // get variables from EQSYSTEM
  BackendDAE.EQSYSTEM(orderedVars = vars) := syst;
  varLst := BackendVariable.varList(vars);
  // translate each variable into NMBDAE.Variable
  nmbVariables := translateVarList(varLst, nmbVariables);
 
  // Parameter & constants
  varLst := BackendVariable.varList(globalKnownVars);
  // translate each variable into NMBDAE.Variable
  nmbVariables := translateVarList(varLst, nmbVariables); 
end translateVariables;


function translateVarList
  "Used by translateVariables() to do the work."
  input list<BackendDAE.Var> varLst;
  input output list<NMBDAE.Variable> nmbVariables = {};
protected
  // BackendDAE
  DAE.ComponentRef varName "variable name";
  BackendDAE.VarKind varKind "kind of variable";
  DAE.VarDirection varDirection "input, output or bidirectional";
  BackendDAE.Type varType "built-in type or enumeration";
  Option<DAE.Exp> bindExp "Binding expression e.g. for parameters";
  Option<DAE.VariableAttributes> values "values on built-in attributes";  
  // NMBDAE
  NMBDAE.ComponentRef nmbName;
  NMBDAE.Type nmbTp;
  NMBDAE.Kind nmbKind;
  NMBDAE.Direction nmbDirection;
  Option<NMBDAE.Exp> nmbBindExp = NONE();
  Option<NMBDAE.VarAttributes> nmbAttributesO = NONE();
  NMBDAE.VarAttributes nmbAttributes;
  DAE.VariableAttributes val;
algorithm
  for var in varLst loop
    BackendDAE.VAR(varName = varName, varKind = varKind, varDirection = varDirection, 
                    varType = varType, bindExp = bindExp, values = values) := var;
    nmbName := translateCref(varName);
    nmbTp := translateType(varType);
    nmbKind := translateKind(varKind);
    nmbDirection := translateDirection(varDirection);
    nmbBindExp := match bindExp
      local DAE.Exp ex;
      case NONE() then NONE();
      case SOME(ex) then SOME(translateExpression(ex));
    end match;
    nmbAttributesO := match values
      case NONE() then NONE();
      case SOME(val) then SOME(translateVarAttributes(val));
    end match;
      
    nmbVariables := NMBDAE.VARIABLE(name = nmbName, tp = nmbTp, kind = nmbKind, 
                    direction = nmbDirection, bindExp = nmbBindExp, 
                    attributes = nmbAttributesO, comment = "")::nmbVariables;
  end for;
end translateVarList;


function translateType
  "Tranform a BackendDAE.Type into a NMBDAE.Type."
  input BackendDAE.Type varType "built-in type or enumeration";
  output NMBDAE.Type nmbTp;
protected
 list<DAE.Var> varLst;
algorithm
  nmbTp := match varType
    case DAE.T_INTEGER(varLst) then NMBDAE.T_INTEGER();
    case DAE.T_REAL(varLst) then NMBDAE.T_REAL();
    case DAE.T_BOOL(varLst) then NMBDAE.T_BOOL();
    case DAE.T_STRING(varLst) then NMBDAE.T_STRING();
    else
    algorithm
      print("\nNMBDAECreate.translateType(): Kind of type not supported.\n");
    then fail();
  end match;

end translateType;


function translateKind
  "Tranform a BackendDAE.VarKind into a NMBDAE.Kind."
  input BackendDAE.VarKind varKind "kind of variable";
  output NMBDAE.Kind nmbKind;

algorithm
  nmbKind := match varKind
    case BackendDAE.VARIABLE() then NMBDAE.K_VARIABLE();
    case BackendDAE.STATE(_,_,_) then NMBDAE.K_STATE();
    case BackendDAE.STATE_DER() then NMBDAE.K_DER_STATE();
    case BackendDAE.DUMMY_DER() then NMBDAE.K_DUMMY_DER();
    case BackendDAE.DUMMY_STATE() then NMBDAE.K_DUMMY_STATE();
    case BackendDAE.PARAM() then NMBDAE.K_PARAMETER();
    case BackendDAE.CONST() then NMBDAE.K_CONSTANT();
    else
    algorithm
      print("\nNMBDAECreate.translateKind(): This kind is not supported.\n");
    then fail();
  end match;
end translateKind;
 

function translateDirection
  "Tranform a DAE.VarDirection into a NMBDAE.Direction."
  input DAE.VarDirection varDirection "input, output or bidirectional";
  output NMBDAE.Direction nmbDirection;
algorithm
  nmbDirection := match varDirection
  case DAE.INPUT() then NMBDAE.INPUT();
  case DAE.OUTPUT() then NMBDAE.OUTPUT();
  case DAE.BIDIR() then NMBDAE.NODIR();
  else
  algorithm
    print("\nNMBDAECreate.translateDirection(): This direction is not supported.\n");
  then fail();
  end match;
end translateDirection;
  
  
function translateVarAttributes
  "Tranform a DAE.VariableAttributes into a NMBDAE.VarAttributes."
  input DAE.VariableAttributes values "values on built-in attributes";
  output NMBDAE.VarAttributes nmbAttributes;
protected
  Option<DAE.Exp> start "start value";
  Option<DAE.Exp> fixed "fixed - true: default for parameter/constant, false - default for other variables";
  Option<DAE.Exp> min;
  Option<DAE.Exp> max;
  Option<DAE.Exp> nominal "nominal";
  Option<DAE.Exp> unit "unit";  
algorithm

  nmbAttributes := match values
    case DAE.VAR_ATTR_REAL(start = start, fixed = fixed, min = min, max = max, 
                          nominal = nominal, unit = unit) 
      then translateVarAttributesWork(start = start, fixed = fixed, min = min, max = max, 
                                      nominal = nominal, unit = unit);

    case DAE.VAR_ATTR_INT(start = start, fixed = fixed, min = min, max = max) 
      then translateVarAttributesWork(start = start, fixed = fixed, min = min, max = max, 
                                      nominal = NONE(), unit = NONE());
    case DAE.VAR_ATTR_BOOL(start = start, fixed = fixed) 
      then translateVarAttributesWork(start = start, fixed = fixed, min = NONE(), max = NONE(), 
                                      nominal = NONE(), unit = NONE());                    

    else NMBDAE.VAR_ATTRIBUTES(NONE(), NONE(), NONE(), NONE(), NONE(), NONE());
  end match;

end translateVarAttributes;


function translateVarAttributesWork
  "Does the work for translateVarAttributes."
  input Option<DAE.Exp> start "start value";
  input Option<DAE.Exp> fixed "fixed - true: default for parameter/constant, false - for other variables";
  input Option<DAE.Exp> min;
  input Option<DAE.Exp> max;
  input Option<DAE.Exp> nominal "nominal";
  input Option<DAE.Exp> unit "unit";
  output NMBDAE.VarAttributes nmbAttributes;
protected  
  DAE.Exp ex;
  // All attributes from NMBDAE
  Option<NMBDAE.Exp> nmbStart = NONE();
  Option<NMBDAE.Exp> nmbFixed = NONE();
  Option<NMBDAE.Exp> nmbMin = NONE();
  Option<NMBDAE.Exp> nmbMax = NONE();
  Option<NMBDAE.Exp> nmbNominal = NONE();
  Option<NMBDAE.Exp> nmbUnit = NONE();
algorithm
  nmbStart := match start
    case NONE() then NONE(); 
    case SOME(ex) then SOME(translateExpression(ex));
  end match;
  
  nmbFixed := match fixed
    case NONE() then NONE();
    case SOME(ex) then SOME(translateExpression(ex));
  end match;
  
  nmbMin := match min
    case NONE() then NONE();
    case SOME(ex) then SOME(translateExpression(ex));
  end match;
  
  nmbMax := match max
    case NONE() then NONE();
    case SOME(ex) then SOME(translateExpression(ex));
  end match;
  
  nmbNominal := match nominal
    case NONE() then NONE();
    case SOME(ex) then SOME(translateExpression(ex));
  end match;

  nmbUnit := match unit
    case NONE() then NONE();
    case SOME(ex) then SOME(translateExpression(ex));
  end match;  

  nmbAttributes := NMBDAE.VAR_ATTRIBUTES(start = nmbStart, fixed = nmbFixed, 
                    min = nmbMin, max = nmbMax, nominal = nmbNominal, unit = nmbUnit);    
end translateVarAttributesWork;


function translateEquations
  "Searches for all equations in the model: equation, solved_equation, residual_equation,...
  Except initial and binding equations.
  "  
  input BackendDAE.EqSystem syst;
  output list<NMBDAE.Equation> nmbEquations = {} "All equations in the model.";
protected  
  BackendDAE.Variables vars;
  BackendDAE.EquationArray eqn_array;
  list<BackendDAE.Equation> eqnList;
  BackendDAE.EquationKind eqnKind;
algorithm
  BackendDAE.EQSYSTEM(orderedVars = vars, orderedEqs = eqn_array) := syst;
  // process dynamic equations
  eqnList := BackendEquation.equationList(eqn_array);
  for eqn in eqnList loop
    eqnKind := BackendEquation.equationKind(eqn);
    _ := match eqnKind
      case BackendDAE.DYNAMIC_EQUATION()
      algorithm
        nmbEquations := translateEquation(eqn)::nmbEquations;
      then "";
      else "";
    end match;
  end for; 
end translateEquations;


function translateInitialEquations
  "Searches for all initial equations in the model.
  "
  input BackendDAE.EquationArray ieqnarr;
  output list<NMBDAE.Equation> nmbInitialEquations = {} "Exclusive initial equations in the model.";
protected
  list<BackendDAE.Equation> eqnList;
  BackendDAE.EquationKind eqnKind;
algorithm
  eqnList := BackendEquation.equationList(ieqnarr);
  for eqn in eqnList loop
    eqnKind := BackendEquation.equationKind(eqn);
    _ := match eqnKind
      case BackendDAE.INITIAL_EQUATION()
      algorithm
        nmbInitialEquations := translateEquation(eqn)::nmbInitialEquations;
      then "";
      else "";
    end match;
  end for;
end translateInitialEquations;


function translateBindingEquations
  "Searches for all binding equations in the model.
  "
  input BackendDAE.EqSystem syst;
  output list<NMBDAE.Equation> nmbBindingEquations = {} "All binding equations in the model.";
protected
  BackendDAE.Variables vars;
  BackendDAE.EquationArray eqn_array;
  list<BackendDAE.Equation> eqnList;
  BackendDAE.EquationKind eqnKind;
  NMBDAE.Equation nmbEqn;
algorithm
  BackendDAE.EQSYSTEM(orderedVars = vars, orderedEqs = eqn_array) := syst;
  eqnList := BackendEquation.equationList(eqn_array);
  for eqn in eqnList loop
    eqnKind := BackendEquation.equationKind(eqn);
    _ := match eqnKind
      case BackendDAE.BINDING_EQUATION()
      algorithm
        nmbBindingEquations := translateEquation(eqn)::nmbBindingEquations;
      then "";
      else "";
    end match;
  end for;  
end translateBindingEquations;


function translateEquation
  "Takes BackendDAE.Equation (only record EQUATION) and transforms it into a NMB Equation."
  input BackendDAE.Equation inEqn;
  output NMBDAE.Equation outEqn;
protected
  DAE.Exp exp1, exp2;
  BackendDAE.EquationAttributes attr;
algorithm
  _ := match inEqn
  case BackendDAE.EQUATION(exp = exp1, scalar = exp2, attr = attr)
  algorithm
    outEqn := NMBDAE.EQUATION(translateExpression(exp1), translateExpression(exp2));
  then "";
  
  else 
  algorithm
    print("NMBDAECreate.translateEquation(): NOT Supported: translateEquation: " + BackendDump.equationString(inEqn));
    outEqn := NMBDAE.EQUATION(NMBDAE.REAL(0.0), NMBDAE.REAL(0.0));
  then "";
  end match;
end translateEquation;


function translateExpression
  "Takes a DAE.Expression and transforms it into a NMB Expression."
  input DAE.Exp inExp;
  output NMBDAE.Exp outExp;
protected
algorithm
  outExp := match inExp
    local Integer i;
      Real r;
      Boolean b;
      String s;
      DAE.Exp ex1, ex2, ex3;
      DAE.Operator op;
      DAE.ComponentRef cref;
      DAE.Type ty;
      list<DAE.Exp> expList;
      list<NMBDAE.Exp> nmbExpLst = {};
      Absyn.Path path;
  case DAE.ICONST(i) then NMBDAE.INT(i);
  case DAE.RCONST(r) then NMBDAE.REAL(r);
  case DAE.BCONST(b) then NMBDAE.BOOL(b);
  case DAE.SCONST(s) then NMBDAE.STRING(s);
  case DAE.CREF(cref, ty) then NMBDAE.CREF(translateCref(cref));
  case DAE.BINARY(ex1, op, ex2) then NMBDAE.BINARY(translateExpression(ex1),translateBinOperator(op),translateExpression(ex2));
  case DAE.UNARY(op, ex1) then NMBDAE.UNARY(translateUnOperator(op), translateExpression(ex1));
  case DAE.CALL(path = path, expLst = expList) // without CallAttributes
  algorithm
    for ex in expList loop
      nmbExpLst := translateExpression(ex)::nmbExpLst;
    end for;
  then NMBDAE.CALL(AbsynUtil.pathString(path), listReverse(nmbExpLst));

  // TODO: This is bad! NMB doesn't support if expressions. But 
  // some MSL classes (SineVoltage for instance) use it in the form:
  // if simulation.time < some.time then 0.0 else some other expression
  case DAE.IFEXP(expCond = ex1, expThen = ex2, expElse = ex3)
  then translateExpression(ex3);
  
  else
  algorithm
    print("NMBDAECreate.translateExpression() failed:\n");
    print(ExpressionDump.printExpStr(inExp));
  then fail();
  end match;
end translateExpression;


function translateCref
  "Tranform a DAE.ComponentRef into a NMB ComponentRef.
  Subscripts and Types are not part of an NMDDAE.ComponentRef"
  input DAE.ComponentRef inCref;
  output NMBDAE.ComponentRef outCref;
protected
  String s;
  DAE.ComponentRef qual;
algorithm
  outCref := match inCref
  case DAE.CREF_QUAL(ident = s, componentRef = qual) then NMBDAE.COMPONENT_REF(s, SOME(translateCref(qual)));
  case DAE.CREF_IDENT(ident = s) then NMBDAE.COMPONENT_REF(s, NONE());
  
  else
  algorithm
    print("NMBDAECreate.translateCref() failed: ComponentRef Type not supported!\n");
  then fail();
  end match;
end translateCref;


function translateUnOperator
  "Tranform a DAE.Operator into a NMB unary operator."
  input DAE.Operator inOp;
  output NMBDAE.UnOp uop;
algorithm  
  uop := match inOp
  case DAE.UMINUS(_) then NMBDAE.NEG();
  
  else
  algorithm
    print("NMBDAECreate.translateUnOperator() failed: Unsupported unary operator.\n");
  then fail();
  end match;
end translateUnOperator;


function translateBinOperator
  "Tranform a DAE.Operator into a NMB binary operator."
  input DAE.Operator inOp;
  output NMBDAE.BinOp bop;
algorithm  
  bop := match inOp
  case DAE.ADD(_) then NMBDAE.ADD();
  case DAE.SUB(_) then NMBDAE.SUB();
  case DAE.MUL(_) then NMBDAE.MUL();
  case DAE.DIV(_) then NMBDAE.DIV();
  case DAE.POW(_) then NMBDAE.POW();
  else
  algorithm
    print("NMBDAECreate.translateBinOperator() failed: Unsupported binary operator\n");
  then fail();
  end match;  
end translateBinOperator;


function translateExtraInfo
  input BackendDAE.ExtraInfo inInfo;
  output NMBDAE.ExtraInfo outInfo;

  algorithm
      outInfo := match inInfo
        local String s1, s2;
      case BackendDAE.EXTRA_INFO(s1, s2) 
      then NMBDAE.EXTRA_INFO(s1, s2);
      else NMBDAE.EXTRA_INFO("", "unknown");
    end match;
end translateExtraInfo;

annotation(__OpenModelica_Interface="backend");
end NMBDAECreate;