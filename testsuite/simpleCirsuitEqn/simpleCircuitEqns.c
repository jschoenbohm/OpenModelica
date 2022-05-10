/* Main Simulation File */

#if defined(__cplusplus)
extern "C" {
#endif

#include "simpleCircuitEqns_model.h"
#include "simulation/solver/events.h"

/* FIXME these defines are ugly and hard to read, why not use direct function pointers instead? */
#define prefixedName_performSimulation simpleCircuitEqns_performSimulation
#define prefixedName_updateContinuousSystem simpleCircuitEqns_updateContinuousSystem
#include <simulation/solver/perform_simulation.c.inc>

#define prefixedName_performQSSSimulation simpleCircuitEqns_performQSSSimulation
#include <simulation/solver/perform_qss_simulation.c.inc>


/* dummy VARINFO and FILEINFO */
const FILE_INFO dummyFILE_INFO = omc_dummyFileInfo;
const VAR_INFO dummyVAR_INFO = omc_dummyVarInfo;

int simpleCircuitEqns_input_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int simpleCircuitEqns_input_function_init(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int simpleCircuitEqns_input_function_updateStartValues(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int simpleCircuitEqns_inputNames(DATA *data, char ** names){
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int simpleCircuitEqns_data_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  TRACE_POP
  return 0;
}

int simpleCircuitEqns_dataReconciliationInputNames(DATA *data, char ** names){
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int simpleCircuitEqns_output_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int simpleCircuitEqns_setc_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


/*
equation index: 11
type: SIMPLE_ASSIGN
$cse1 = sin(6.283185308 * f * time)
*/
void simpleCircuitEqns_eqFunction_11(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,11};
  (data->localData[0]->realVars[4]/* $cse1 variable */)  = sin(((6.283185308) * ((data->simulationInfo->realParameter[5]/* f PARAM */) )) * (data->localData[0]->timeValue));
  TRACE_POP
}
/*
equation index: 12
type: SIMPLE_ASSIGN
u3 = R2 * i2
*/
void simpleCircuitEqns_eqFunction_12(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,12};
  (data->localData[0]->realVars[9]/* u3 variable */)  = ((data->simulationInfo->realParameter[4]/* R2 PARAM */) ) * ((data->localData[0]->realVars[0]/* i2 STATE(1) */) );
  TRACE_POP
}
/*
equation index: 13
type: SIMPLE_ASSIGN
u = A * $cse1
*/
void simpleCircuitEqns_eqFunction_13(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,13};
  (data->localData[0]->realVars[7]/* u variable */)  = ((data->simulationInfo->realParameter[0]/* A PARAM */) ) * ((data->localData[0]->realVars[4]/* $cse1 variable */) );
  TRACE_POP
}
/*
equation index: 14
type: SIMPLE_ASSIGN
u1 = u - u2
*/
void simpleCircuitEqns_eqFunction_14(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,14};
  (data->localData[0]->realVars[8]/* u1 variable */)  = (data->localData[0]->realVars[7]/* u variable */)  - (data->localData[0]->realVars[1]/* u2 STATE(1) */) ;
  TRACE_POP
}
/*
equation index: 15
type: SIMPLE_ASSIGN
i1 = u1 / R1
*/
void simpleCircuitEqns_eqFunction_15(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,15};
  (data->localData[0]->realVars[6]/* i1 variable */)  = DIVISION_SIM((data->localData[0]->realVars[8]/* u1 variable */) ,(data->simulationInfo->realParameter[3]/* R1 PARAM */) ,"R1",equationIndexes);
  TRACE_POP
}
/*
equation index: 16
type: SIMPLE_ASSIGN
i = i1 + i2
*/
void simpleCircuitEqns_eqFunction_16(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,16};
  (data->localData[0]->realVars[5]/* i variable */)  = (data->localData[0]->realVars[6]/* i1 variable */)  + (data->localData[0]->realVars[0]/* i2 STATE(1) */) ;
  TRACE_POP
}
/*
equation index: 17
type: SIMPLE_ASSIGN
$DER.u2 = i1 / C
*/
void simpleCircuitEqns_eqFunction_17(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,17};
  (data->localData[0]->realVars[3]/* der(u2) STATE_DER */)  = DIVISION_SIM((data->localData[0]->realVars[6]/* i1 variable */) ,(data->simulationInfo->realParameter[1]/* C PARAM */) ,"C",equationIndexes);
  TRACE_POP
}
/*
equation index: 18
type: SIMPLE_ASSIGN
u4 = u - u3
*/
void simpleCircuitEqns_eqFunction_18(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,18};
  (data->localData[0]->realVars[10]/* u4 variable */)  = (data->localData[0]->realVars[7]/* u variable */)  - (data->localData[0]->realVars[9]/* u3 variable */) ;
  TRACE_POP
}
/*
equation index: 19
type: SIMPLE_ASSIGN
$DER.i2 = u4 / L
*/
void simpleCircuitEqns_eqFunction_19(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,19};
  (data->localData[0]->realVars[2]/* der(i2) STATE_DER */)  = DIVISION_SIM((data->localData[0]->realVars[10]/* u4 variable */) ,(data->simulationInfo->realParameter[2]/* L PARAM */) ,"L",equationIndexes);
  TRACE_POP
}
/*
equation index: 20
type: ALGORITHM

  assert(u == i, "Ein ASSERT!");
*/
void simpleCircuitEqns_eqFunction_20(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,20};
  static const MMC_DEFSTRINGLIT(tmp1,11,"Ein ASSERT!");
  static int tmp2 = 0;
  if(!tmp2)
  {
    if(!((data->localData[0]->realVars[7]/* u variable */)  == (data->localData[0]->realVars[5]/* i variable */) ))
    {
      {
        if (data->simulationInfo->noThrowAsserts) {
          infoStreamPrintWithEquationIndexes(LOG_ASSERT, 0, equationIndexes, "The following assertion has been violated %sat time %f\nu == i", initial() ? "during initialization " : "", data->localData[0]->timeValue);
          infoStreamPrint(LOG_ASSERT, 0, "%s", MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp1)));
        } else {
          FILE_INFO info = {"D:/Programme/OpenModelica/testsuite/simpleCirsuitEqn/simpleCircuitEqns.mo",14,3,14,62,0};
          omc_assert_warning(info, "The following assertion has been violated %sat time %f\nu == i", initial() ? "during initialization " : "", data->localData[0]->timeValue);
          omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp1)));
        }
      }
      tmp2 = 1;
    }
  }
  TRACE_POP
}

OMC_DISABLE_OPT
int simpleCircuitEqns_functionDAE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  int equationIndexes[1] = {0};
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_DAE);
#endif

  data->simulationInfo->needToIterate = 0;
  data->simulationInfo->discreteCall = 1;
  simpleCircuitEqns_functionLocalKnownVars(data, threadData);
  simpleCircuitEqns_eqFunction_11(data, threadData);

  simpleCircuitEqns_eqFunction_12(data, threadData);

  simpleCircuitEqns_eqFunction_13(data, threadData);

  simpleCircuitEqns_eqFunction_14(data, threadData);

  simpleCircuitEqns_eqFunction_15(data, threadData);

  simpleCircuitEqns_eqFunction_16(data, threadData);

  simpleCircuitEqns_eqFunction_17(data, threadData);

  simpleCircuitEqns_eqFunction_18(data, threadData);

  simpleCircuitEqns_eqFunction_19(data, threadData);

  simpleCircuitEqns_eqFunction_20(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_DAE);
#endif
  TRACE_POP
  return 0;
}


int simpleCircuitEqns_functionLocalKnownVars(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


/* forwarded equations */
extern void simpleCircuitEqns_eqFunction_11(DATA* data, threadData_t *threadData);
extern void simpleCircuitEqns_eqFunction_12(DATA* data, threadData_t *threadData);
extern void simpleCircuitEqns_eqFunction_13(DATA* data, threadData_t *threadData);
extern void simpleCircuitEqns_eqFunction_14(DATA* data, threadData_t *threadData);
extern void simpleCircuitEqns_eqFunction_15(DATA* data, threadData_t *threadData);
extern void simpleCircuitEqns_eqFunction_17(DATA* data, threadData_t *threadData);
extern void simpleCircuitEqns_eqFunction_18(DATA* data, threadData_t *threadData);
extern void simpleCircuitEqns_eqFunction_19(DATA* data, threadData_t *threadData);

static void functionODE_system0(DATA *data, threadData_t *threadData)
{
  {
    simpleCircuitEqns_eqFunction_11(data, threadData);
    threadData->lastEquationSolved = 11;
  }
  {
    simpleCircuitEqns_eqFunction_12(data, threadData);
    threadData->lastEquationSolved = 12;
  }
  {
    simpleCircuitEqns_eqFunction_13(data, threadData);
    threadData->lastEquationSolved = 13;
  }
  {
    simpleCircuitEqns_eqFunction_14(data, threadData);
    threadData->lastEquationSolved = 14;
  }
  {
    simpleCircuitEqns_eqFunction_15(data, threadData);
    threadData->lastEquationSolved = 15;
  }
  {
    simpleCircuitEqns_eqFunction_17(data, threadData);
    threadData->lastEquationSolved = 17;
  }
  {
    simpleCircuitEqns_eqFunction_18(data, threadData);
    threadData->lastEquationSolved = 18;
  }
  {
    simpleCircuitEqns_eqFunction_19(data, threadData);
    threadData->lastEquationSolved = 19;
  }
}

int simpleCircuitEqns_functionODE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_FUNCTION_ODE);
#endif

  
  data->simulationInfo->callStatistics.functionODE++;
  
  simpleCircuitEqns_functionLocalKnownVars(data, threadData);
  functionODE_system0(data, threadData);

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_FUNCTION_ODE);
#endif

  TRACE_POP
  return 0;
}

/* forward the main in the simulation runtime */
extern int _main_SimulationRuntime(int argc, char**argv, DATA *data, threadData_t *threadData);

#include "simpleCircuitEqns_12jac.h"
#include "simpleCircuitEqns_13opt.h"

struct OpenModelicaGeneratedFunctionCallbacks simpleCircuitEqns_callback = {
   (int (*)(DATA *, threadData_t *, void *)) simpleCircuitEqns_performSimulation,    /* performSimulation */
   (int (*)(DATA *, threadData_t *, void *)) simpleCircuitEqns_performQSSSimulation,    /* performQSSSimulation */
   simpleCircuitEqns_updateContinuousSystem,    /* updateContinuousSystem */
   simpleCircuitEqns_callExternalObjectDestructors,    /* callExternalObjectDestructors */
   NULL,    /* initialNonLinearSystem */
   NULL,    /* initialLinearSystem */
   NULL,    /* initialMixedSystem */
   #if !defined(OMC_NO_STATESELECTION)
   simpleCircuitEqns_initializeStateSets,
   #else
   NULL,
   #endif    /* initializeStateSets */
   simpleCircuitEqns_initializeDAEmodeData,
   simpleCircuitEqns_functionODE,
   simpleCircuitEqns_functionAlgebraics,
   simpleCircuitEqns_functionDAE,
   simpleCircuitEqns_functionLocalKnownVars,
   simpleCircuitEqns_input_function,
   simpleCircuitEqns_input_function_init,
   simpleCircuitEqns_input_function_updateStartValues,
   simpleCircuitEqns_data_function,
   simpleCircuitEqns_output_function,
   simpleCircuitEqns_setc_function,
   simpleCircuitEqns_function_storeDelayed,
   simpleCircuitEqns_function_storeSpatialDistribution,
   simpleCircuitEqns_function_initSpatialDistribution,
   simpleCircuitEqns_updateBoundVariableAttributes,
   simpleCircuitEqns_functionInitialEquations,
   1, /* useHomotopy - 0: local homotopy (equidistant lambda), 1: global homotopy (equidistant lambda), 2: new global homotopy approach (adaptive lambda), 3: new local homotopy approach (adaptive lambda)*/
   NULL,
   simpleCircuitEqns_functionRemovedInitialEquations,
   simpleCircuitEqns_updateBoundParameters,
   simpleCircuitEqns_checkForAsserts,
   simpleCircuitEqns_function_ZeroCrossingsEquations,
   simpleCircuitEqns_function_ZeroCrossings,
   simpleCircuitEqns_function_updateRelations,
   simpleCircuitEqns_zeroCrossingDescription,
   simpleCircuitEqns_relationDescription,
   simpleCircuitEqns_function_initSample,
   simpleCircuitEqns_INDEX_JAC_A,
   simpleCircuitEqns_INDEX_JAC_B,
   simpleCircuitEqns_INDEX_JAC_C,
   simpleCircuitEqns_INDEX_JAC_D,
   simpleCircuitEqns_INDEX_JAC_F,
   simpleCircuitEqns_initialAnalyticJacobianA,
   simpleCircuitEqns_initialAnalyticJacobianB,
   simpleCircuitEqns_initialAnalyticJacobianC,
   simpleCircuitEqns_initialAnalyticJacobianD,
   simpleCircuitEqns_initialAnalyticJacobianF,
   simpleCircuitEqns_functionJacA_column,
   simpleCircuitEqns_functionJacB_column,
   simpleCircuitEqns_functionJacC_column,
   simpleCircuitEqns_functionJacD_column,
   simpleCircuitEqns_functionJacF_column,
   simpleCircuitEqns_linear_model_frame,
   simpleCircuitEqns_linear_model_datarecovery_frame,
   simpleCircuitEqns_mayer,
   simpleCircuitEqns_lagrange,
   simpleCircuitEqns_pickUpBoundsForInputsInOptimization,
   simpleCircuitEqns_setInputData,
   simpleCircuitEqns_getTimeGrid,
   simpleCircuitEqns_symbolicInlineSystem,
   simpleCircuitEqns_function_initSynchronous,
   simpleCircuitEqns_function_updateSynchronous,
   simpleCircuitEqns_function_equationsSynchronous,
   simpleCircuitEqns_inputNames,
   simpleCircuitEqns_dataReconciliationInputNames,
   NULL,
   NULL,
   NULL,
   -1,
   NULL,
   NULL,
   -1

};

#define _OMC_LIT_RESOURCE_0_name_data "simpleCircuitEqns"
#define _OMC_LIT_RESOURCE_0_dir_data "D:/Programme/OpenModelica/testsuite/simpleCirsuitEqn"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_0_name,17,_OMC_LIT_RESOURCE_0_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_0_dir,52,_OMC_LIT_RESOURCE_0_dir_data);

static const MMC_DEFSTRUCTLIT(_OMC_LIT_RESOURCES,2,MMC_ARRAY_TAG) {MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_dir)}};
void simpleCircuitEqns_setupDataStruc(DATA *data, threadData_t *threadData)
{
  assertStreamPrint(threadData,0!=data, "Error while initialize Data");
  threadData->localRoots[LOCAL_ROOT_SIMULATION_DATA] = data;
  data->callback = &simpleCircuitEqns_callback;
  OpenModelica_updateUriMapping(threadData, MMC_REFSTRUCTLIT(_OMC_LIT_RESOURCES));
  data->modelData->modelName = "simpleCircuitEqns";
  data->modelData->modelFilePrefix = "simpleCircuitEqns";
  data->modelData->resultFileName = NULL;
  data->modelData->modelDir = "D:/Programme/OpenModelica/testsuite/simpleCirsuitEqn";
  data->modelData->modelGUID = "{d3ca37f4-3f51-49d2-9e43-d5aee758a01e}";
  #if defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME)
  data->modelData->initXMLData = NULL;
  data->modelData->modelDataXml.infoXMLData = NULL;
  #else
  #if defined(_MSC_VER) /* handle joke compilers */
  {
  /* for MSVC we encode a string like char x[] = {'a', 'b', 'c', '\0'} */
  /* because the string constant limit is 65535 bytes */
  static const char contents_init[] =
    #include "simpleCircuitEqns_init.c"
    ;
  static const char contents_info[] =
    #include "simpleCircuitEqns_info.c"
    ;
    data->modelData->initXMLData = contents_init;
    data->modelData->modelDataXml.infoXMLData = contents_info;
  }
  #else /* handle real compilers */
  data->modelData->initXMLData =
  #include "simpleCircuitEqns_init.c"
    ;
  data->modelData->modelDataXml.infoXMLData =
  #include "simpleCircuitEqns_info.c"
    ;
  #endif /* defined(_MSC_VER) */
  #endif /* defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME) */
  data->modelData->runTestsuite = 0;
  
  data->modelData->nStates = 2;
  data->modelData->nVariablesReal = 11;
  data->modelData->nDiscreteReal = 0;
  data->modelData->nVariablesInteger = 0;
  data->modelData->nVariablesBoolean = 0;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 6;
  data->modelData->nParametersInteger = 0;
  data->modelData->nParametersBoolean = 0;
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  
  data->modelData->nAliasReal = 0;
  data->modelData->nAliasInteger = 0;
  data->modelData->nAliasBoolean = 0;
  data->modelData->nAliasString = 0;
  
  data->modelData->nZeroCrossings = 0;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 0;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 0;
  
  data->modelData->modelDataXml.fileName = "simpleCircuitEqns_info.json";
  data->modelData->modelDataXml.modelInfoXmlLength = 0;
  data->modelData->modelDataXml.nFunctions = 0;
  data->modelData->modelDataXml.nProfileBlocks = 0;
  data->modelData->modelDataXml.nEquations = 21;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 0;
  data->modelData->nNonLinearSystems = 0;
  data->modelData->nStateSets = 0;
  data->modelData->nJacobians = 5;
  data->modelData->nOptimizeConstraints = 0;
  data->modelData->nOptimizeFinalConstraints = 0;
  
  data->modelData->nDelayExpressions = 0;
  
  data->modelData->nBaseClocks = 0;
  
  data->modelData->nSpatialDistributions = 0;
  
  data->modelData->nSensitivityVars = 0;
  data->modelData->nSensitivityParamVars = 0;
  data->modelData->nSetcVars = 0;
  data->modelData->ndataReconVars = 0;
  data->modelData->linearizationDumpLanguage =
  OMC_LINEARIZE_DUMP_LANGUAGE_MODELICA;
}

static int rml_execution_failed()
{
  fflush(NULL);
  fprintf(stderr, "Execution failed!\n");
  fflush(NULL);
  return 1;
}

#if defined(threadData)
#undef threadData
#endif
/* call the simulation runtime main from our main! */
int main(int argc, char**argv)
{
  /*
    Set the error functions to be used for simulation.
    The default value for them is 'functions' version. Change it here to 'simulation' versions
  */
  omc_assert = omc_assert_simulation;
  omc_assert_withEquationIndexes = omc_assert_simulation_withEquationIndexes;

  omc_assert_warning_withEquationIndexes = omc_assert_warning_simulation_withEquationIndexes;
  omc_assert_warning = omc_assert_warning_simulation;
  omc_terminate = omc_terminate_simulation;
  omc_throw = omc_throw_simulation;

  int res;
  DATA data;
  MODEL_DATA modelData;
  SIMULATION_INFO simInfo;
  data.modelData = &modelData;
  data.simulationInfo = &simInfo;
  measure_time_flag = 0;
  compiledInDAEMode = 0;
  compiledWithSymSolver = 0;
  MMC_INIT(0);
  omc_alloc_interface.init();
  {
    MMC_TRY_TOP()
  
    MMC_TRY_STACK()
  
    simpleCircuitEqns_setupDataStruc(&data, threadData);
    res = _main_SimulationRuntime(argc, argv, &data, threadData);
    
    MMC_ELSE()
    rml_execution_failed();
    fprintf(stderr, "Stack overflow detected and was not caught.\nSend us a bug report at https://trac.openmodelica.org/OpenModelica/newticket\n    Include the following trace:\n");
    printStacktraceMessages();
    fflush(NULL);
    return 1;
    MMC_CATCH_STACK()
    
    MMC_CATCH_TOP(return rml_execution_failed());
  }

  fflush(NULL);
  EXIT(res);
  return res;
}

#ifdef __cplusplus
}
#endif


