package Main
"
  Beispiel für den Arbeitsablauf bei der Modulentwicklung.
"
  import DAE;
  import DAE_List;
  import DumpDAE; 
  import ConvDAE_List;
  import Data;
  import Expression;
  import DerReplacement;
  
  function main
      input String path = "";
      output String msg = "";
  protected
    DAE.ImportDAE importDAE;
    Integer i = 1;
    list<DAE.Variable> varList ,variableVars ,parameterVars ,stateVars ;
    list<DAE.Equation> eqList;
    DAE.VariableArray variableVarr, parameterVarr, stateVarr;
    array<Integer> assign1, assign2;
    array<DAE.Variable> vars;
    DAE.AdjacencyMatrix  aMatrix, aMatrixT;
    DAE.Matching matching;
    DAE.StrongComponents stComp;
    list<list<Integer>> equationIndices;
    DAE.BackendDAE bDAE;
    DAE.EquationSystem simulation, initialization;
    DAE.Shared shared;
    DAE.Equation eq;
    DAE.Variable v;
    String s1 = "";
    String filename = "model";
  algorithm
  
  // Daten laden und konvertieren.
    importDAE := Data.getModel();
    importDAE := DerReplacement.identifyStates(importDAE);

  // Dump der Daten für den Vergleich mit den erwarteten Daten.  
    msg := msg + "Imported Equations\n";
    for eq in importDAE.equations loop
      msg := msg + "Eq[" + String(i) + "]: " + Expression.expToString(eq.lhs) + " = " + Expression.expToString(eq.rhs) + "\n\n";
      i := i + 1;
    end for;  
    msg := msg +"\n";
    
    // variables
    msg := msg + "Imported Variables\n";
    varList := importDAE.variables;
    msg := msg + "Number of Variables: " + String(listLength(varList)) + "\n";
    msg := msg + showVariableList(varList);   
    msg := msg +"\n"; 
    
// BackendDAE erzeugen    
    msg := msg + "\nBackendDAECreate\n";
    i := 1;
    bDAE := BackendDAECreate.convertImportDAEtoBackendDAE(importDAE);
    simulation := bDAE.simulation;
    initialization := bDAE.initialization;
    shared := bDAE.shared;
    
  // Show the simulation equationsystem
    // equations
    msg := msg + "Simulation has " + String(simulation.equations.size) + " Equations\n";
    for eq in simulation.equations.equations loop
      msg := msg + "Eq[" + String(i) + "]: " + Expression.expToString(eq.lhs) + " = " + Expression.expToString(eq.rhs) + "\n\n";
      i := i + 1;
    end for;
    msg := msg +"\n";
    
    // variables
    variableVarr := simulation.variables;
    msg := msg + "Size of Array: " + String(variableVarr.size) + "\n";
    msg := msg + showVariableArray(variableVarr);   
    msg := msg +"\n";
    
// Remove simple equations    
    msg := msg + "\nRemoveSimpleEquations\n";
    //simulation := RemoveSimpleEquations.removeSimpleEquations(simulation, shared);
    
  // Show the simulation equationsystem
    // equations
    i := 1;
    msg := msg + "Simulation has " + String(simulation.equations.size) + " Equations\n";
    for eq in simulation.equations.equations loop
      msg := msg + "Eq[" + String(i) + "]: " + Expression.expToString(eq.lhs) + " = " + Expression.expToString(eq.rhs) + "\n\n";
      i := i + 1;
    end for;
    msg := msg +"\n";
    
    // variables
    variableVarr := simulation.variables;
    msg := msg + "Size of Array: " + String(variableVarr.size) + "\n";
    msg := msg + showVariableArray(variableVarr);   
    msg := msg +"\n";     
      
  // Matching
    // create and show the AdjacencyMatrix 
    (aMatrix,aMatrixT) := BackendDAEUtil.adjacencyMatrix(simulation.variables, simulation.equations);
    simulation.adjacency := SOME(aMatrix);
    simulation.adjacencyTranspose := SOME(aMatrixT);
    
    msg := msg + "\nAdjacencyMatrix\n";
    i := 1;
    for r in aMatrix loop
      msg := msg + "Eqn " + String(i) + " : ";
      i := i + 1;
      for c in r loop
        msg := msg + String(c) + " ";
      end for;
      msg := msg + "\n";
    end for;
    msg := msg +"\n";  
    
    // perform and show the matching
    msg := msg + "\nMatching\n";
    try
      DAE.MATCHING(variableAssign = assign1, equationAssign = assign2) := Matching.PerfectMatching(aMatrix);
      i := 1;
      for idx in assign1 loop
        msg := msg + "var["+ String(i) +"] solved by equ " + String(idx) + "\n";
        i := i+1;
      end for;
      msg := msg + "\n";
      i := 1;
      for idx in assign2 loop
        msg := msg + "eqn["+ String(i) +"] solves var " + String(idx) + "\n";
        i := i+1;
      end for;      
    else
      msg := msg + "\nError: Matching failed!";
    end try;
    matching := DAE.MATCHING( variableAssign = assign1,equationAssign = assign2 );
 
    simulation.matching := SOME(matching);
    msg := msg +"\n";

  // Sorting    
    // sort it and show the strongsomponents   
    msg := msg + "\nStrong components\n";    
    equationIndices := Sorting.tarjan(aMatrix,matching.variableAssign); 
    
    stComp:= List.listReverse(Sorting.setStrongComponents(equationIndices, matching));  
    for stc in stComp loop
      msg := msg + DumpDAE.dumpStrongComponent(stc) + "\n";
    end for;
    simulation.strongComponents := stComp;    

  
  // Simplify, solve
    // solve Equations
    msg := msg + "\nSolved System\n";
    simulation := EquationSolve.solveEquation(simulation);

    i := 1;
    msg := msg + "Simulation has " + String(simulation.equations.size) + " Equations\n";
    for eq in simulation.equations.equations loop
      msg := msg + "Eq[" + String(i) + "]: " + Expression.expToString(eq.lhs) + " = " + Expression.expToString(eq.rhs) + "\n\n";
      i := i + 1;
    end for;
    msg := msg +"\n";

  
  // TODO: Das läuft noch nicht!!!!!!!!!!!
  // Show the initial system
    (aMatrix,aMatrixT) := BackendDAEUtil.adjacencyMatrix(initialization.variables, initialization.equations);
    initialization.adjacency := SOME(aMatrix);
    initialization.adjacencyTranspose := SOME(aMatrixT);    
    msg := msg +"\n";
    

// Show the shared data
    // Parameter and constants in shared
    msg := msg + "\nParameter and constants\n"; 
    variableVarr := shared.parameterVariables; 
    msg := msg + "Size of Array: " + String(variableVarr.size) + "\n";
    msg := msg + showVariableArray(variableVarr);       
    msg := msg +"\n";
    
    // States in shared
    msg := msg + "\nStates\n"; 
    variableVarr := shared.stateVariables; 
    msg := msg + "Size of Array: " + String(variableVarr.size) + "\n";
    msg := msg + showVariableArray(variableVarr);    
    msg := msg +"\n";
    
    // Alias in shared
    msg := msg + "\nAlias variables\n"; 
    variableVarr := shared.aliasVariables; 
    msg := msg + "Size of Array: " + String(variableVarr.size) + "\n";
    msg := msg + showVariableArray(variableVarr);
 
// Simplify, write Matlab code
  DAE.EXTRA_INFO(s1, filename) := shared.info;
  CodegenMatlab.translateModel("", "nmb_" + filename, DAE.BACKENDDAE(simulation,initialization,shared));

 
  end main;    
     
// ********************** PROTECTED *****************************************
  protected function showVariableArray
    input DAE.VariableArray variableVarr;
    output String msg = "";
  protected
    array<DAE.Variable> vars;
    Integer i;
    String s1;
  algorithm
    vars := variableVarr.variables;
    i := 1;
    for i in 1:variableVarr.size loop
      msg := msg + "Var[" + String(i) + "] = " + ComponentRef.ComponentRefToStr1(vars[i].name) + "\t" + DumpDAE.dumpKind(vars[i].kind);
      s1 := match vars[i].bindExp
      local 
        DAE.Exp exp1;
      case SOME(exp1)
      then "\t=\t" + Expression.expToString(exp1);
      else "";
      end match;
      msg := msg + s1 + "\n";
    end for;
    msg := msg +"\n";
    msg := msg +"array<list<   ComponentRef cref;      Integer index;   > >\n";
    i := 1;
    for vi in variableVarr.variableIndices loop
      if listLength(vi) > 0 then
        msg := msg + "List[" + String(i) + "] = {";
        for ci in vi loop // ci is a CrefIndex taken from a list.
          msg := msg + ComponentRef.ComponentRefToStr1(ci.cref) + "\t::\t" + String(ci.index) + " || ";
        end for;
        msg := msg + "}\n";
      end if;
      i := i +1;
    end for;  
  end showVariableArray;
  
  protected function showVariableList
    input list<DAE.Variable> variableList;
    output String msg = "";
  protected
    String s1 = "";
    Integer i;
  algorithm
    i := 1;
    for var in variableList loop
      msg := msg + "Var[" + String(i) + "] = " + ComponentRef.ComponentRefToStr1(var.name) + "\n";
      s1 := match var.bindExp
      local 
        DAE.Exp exp1;
      case SOME(exp1)
      then "\t=\t" + Expression.expToString(exp1);
      else "";
      end match;
      msg := msg + s1 + "\n";
      i := i + 1;
    end for;
    msg := msg +"\n";
  end showVariableList;     
     
end Main;
