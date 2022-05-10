/* Initialization */
#include "simpleCircuitEqns_model.h"
#include "simpleCircuitEqns_11mix.h"
#include "simpleCircuitEqns_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

void simpleCircuitEqns_functionInitialEquations_0(DATA *data, threadData_t *threadData);

/*
equation index: 1
type: SIMPLE_ASSIGN
u = A * sin(6.283185308 * f * time)
*/
void simpleCircuitEqns_eqFunction_1(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1};
  (data->localData[0]->realVars[7]/* u variable */)  = ((data->simulationInfo->realParameter[0]/* A PARAM */) ) * (sin(((6.283185308) * ((data->simulationInfo->realParameter[5]/* f PARAM */) )) * (data->localData[0]->timeValue)));
  TRACE_POP
}

/*
equation index: 2
type: SIMPLE_ASSIGN
$DER.i2 = 0.0
*/
void simpleCircuitEqns_eqFunction_2(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,2};
  (data->localData[0]->realVars[2]/* der(i2) STATE_DER */)  = 0.0;
  TRACE_POP
}

/*
equation index: 3
type: SIMPLE_ASSIGN
u4 = L * $DER.i2
*/
void simpleCircuitEqns_eqFunction_3(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3};
  (data->localData[0]->realVars[10]/* u4 variable */)  = ((data->simulationInfo->realParameter[2]/* L PARAM */) ) * ((data->localData[0]->realVars[2]/* der(i2) STATE_DER */) );
  TRACE_POP
}

/*
equation index: 4
type: SIMPLE_ASSIGN
u3 = u - u4
*/
void simpleCircuitEqns_eqFunction_4(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4};
  (data->localData[0]->realVars[9]/* u3 variable */)  = (data->localData[0]->realVars[7]/* u variable */)  - (data->localData[0]->realVars[10]/* u4 variable */) ;
  TRACE_POP
}

/*
equation index: 5
type: SIMPLE_ASSIGN
i2 = u3 / R2
*/
void simpleCircuitEqns_eqFunction_5(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,5};
  (data->localData[0]->realVars[0]/* i2 STATE(1) */)  = DIVISION_SIM((data->localData[0]->realVars[9]/* u3 variable */) ,(data->simulationInfo->realParameter[4]/* R2 PARAM */) ,"R2",equationIndexes);
  TRACE_POP
}

/*
equation index: 6
type: SIMPLE_ASSIGN
$DER.u2 = 0.0
*/
void simpleCircuitEqns_eqFunction_6(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,6};
  (data->localData[0]->realVars[3]/* der(u2) STATE_DER */)  = 0.0;
  TRACE_POP
}

/*
equation index: 7
type: SIMPLE_ASSIGN
i1 = C * $DER.u2
*/
void simpleCircuitEqns_eqFunction_7(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,7};
  (data->localData[0]->realVars[6]/* i1 variable */)  = ((data->simulationInfo->realParameter[1]/* C PARAM */) ) * ((data->localData[0]->realVars[3]/* der(u2) STATE_DER */) );
  TRACE_POP
}

/*
equation index: 8
type: SIMPLE_ASSIGN
u1 = R1 * i1
*/
void simpleCircuitEqns_eqFunction_8(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,8};
  (data->localData[0]->realVars[8]/* u1 variable */)  = ((data->simulationInfo->realParameter[3]/* R1 PARAM */) ) * ((data->localData[0]->realVars[6]/* i1 variable */) );
  TRACE_POP
}

/*
equation index: 9
type: SIMPLE_ASSIGN
u2 = u - u1
*/
void simpleCircuitEqns_eqFunction_9(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,9};
  (data->localData[0]->realVars[1]/* u2 STATE(1) */)  = (data->localData[0]->realVars[7]/* u variable */)  - (data->localData[0]->realVars[8]/* u1 variable */) ;
  TRACE_POP
}
extern void simpleCircuitEqns_eqFunction_16(DATA *data, threadData_t *threadData);

OMC_DISABLE_OPT
void simpleCircuitEqns_functionInitialEquations_0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  simpleCircuitEqns_eqFunction_1(data, threadData);
  simpleCircuitEqns_eqFunction_2(data, threadData);
  simpleCircuitEqns_eqFunction_3(data, threadData);
  simpleCircuitEqns_eqFunction_4(data, threadData);
  simpleCircuitEqns_eqFunction_5(data, threadData);
  simpleCircuitEqns_eqFunction_6(data, threadData);
  simpleCircuitEqns_eqFunction_7(data, threadData);
  simpleCircuitEqns_eqFunction_8(data, threadData);
  simpleCircuitEqns_eqFunction_9(data, threadData);
  simpleCircuitEqns_eqFunction_16(data, threadData);
  TRACE_POP
}

int simpleCircuitEqns_functionInitialEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->discreteCall = 1;
  simpleCircuitEqns_functionInitialEquations_0(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
  TRACE_POP
  return 0;
}

/* No simpleCircuitEqns_functionInitialEquations_lambda0 function */

int simpleCircuitEqns_functionRemovedInitialEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int *equationIndexes = NULL;
  double res = 0.0;

  
  TRACE_POP
  return 0;
}


#if defined(__cplusplus)
}
#endif

