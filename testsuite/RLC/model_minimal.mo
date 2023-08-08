package Main
"
  Beispiel für den Arbeitsablauf bei der Modulentwicklung.
"
  import DAE;
  import Data;
  import DerReplacement;
  import Sorting;
  import Matching;
  import BackendDAEUtil;
  import BackendDAECreate;
  import RemoveSimpleEquations;
  import Expression;
  
  function main
      input String path = "";
      output String msg = "";
  protected
    DAE.ImportDAE importDAE;
    DAE.AdjacencyMatrix  aMatrix, aMatrixT;
    DAE.Matching matching;
    list<list<Integer>> equationIndices;
    DAE.BackendDAE bDAE;
    DAE.EquationSystem simulation, initialization, removed;
    DAE.Shared shared;
    String s1 = "";
    String filename = "model";

Integer i;
  algorithm
  
  // Daten laden und konvertieren.
msg := msg + "Start\n";
    importDAE := Data.getModel();
    importDAE := DerReplacement.identifyStates(importDAE);
    
// BackendDAE erzeugen    
msg := msg + "1\n";
    bDAE := BackendDAECreate.convertImportDAEtoBackendDAE(importDAE);
    simulation := bDAE.simulation;
    initialization := bDAE.initialization;
    shared := bDAE.shared;

// TODO: RemoveSimpleEquations muss noch separat getestet werden!!!
// Remove simple equations    
    //msg := msg + "\nRemoveSimpleEquations\n";
    //(simulation, removed) := RemoveSimpleEquations.removeSimpleEquations(simulation, shared);

    i := 1;
    msg := msg + "Simulation has " + String(simulation.equations.size) + " Equations\n";
    for eq in simulation.equations.equations loop
      msg := msg + "Eq[" + String(i) + "]: " + Expression.expToString(eq.lhs) + " = " + Expression.expToString(eq.rhs) + "\n\n";
      i := i + 1;
    end for;
    msg := msg +"\n";   
      
  // Matching
    // create and show the AdjacencyMatrix 
msg := msg + "2\n";
    (aMatrix,aMatrixT) := BackendDAEUtil.adjacencyMatrix(simulation.variables, simulation.equations);
    simulation.adjacency := SOME(aMatrix);
    simulation.adjacencyTranspose := SOME(aMatrixT);

    try
      matching := Matching.PerfectMatching(aMatrix);      
    else
      msg := msg + "\nError: Matching failed!";
    end try;
    simulation.matching := SOME(matching);

  // Sorting       
msg := msg + "3\n";  
    equationIndices := Sorting.tarjan(aMatrix, matching.variableAssign);     
    simulation.strongComponents:= List.listReverse(Sorting.setStrongComponents(equationIndices, matching));     
  
  // Simplify, solve
msg := msg + "4\n";  
    simulation := EquationSolve.solveEquation(simulation);
 
  // TODO: Das läuft noch nicht!!!!!!!!!!!
  // Show the initial system
msg := msg + "5\n";
    // (aMatrix,aMatrixT) := BackendDAEUtil.adjacencyMatrix(initialization.variables, initialization.equations);
    // initialization.adjacency := SOME(aMatrix);
    // initialization.adjacencyTranspose := SOME(aMatrixT);    
 
// // Simplify, write Matlab code
msg := msg + "6\n";
  DAE.EXTRA_INFO(s1, filename) := shared.info;
  CodegenMatlab.translateModel("", "nmb_" + filename, DAE.BACKENDDAE(simulation,initialization,shared));
msg := msg + "Ende\n";
 
  end main;    
     
end Main;
