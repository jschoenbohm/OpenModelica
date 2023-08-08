/* Algebraic */
#include "simpleCircuitEqns_model.h"

#ifdef __cplusplus
extern "C" {
#endif


/* forwarded equations */
extern void simpleCircuitEqns_eqFunction_16(DATA* data, threadData_t *threadData);
extern void simpleCircuitEqns_eqFunction_20(DATA* data, threadData_t *threadData);

static void functionAlg_system0(DATA *data, threadData_t *threadData)
{
  {
    simpleCircuitEqns_eqFunction_16(data, threadData);
    threadData->lastEquationSolved = 16;
  }
  {
    simpleCircuitEqns_eqFunction_20(data, threadData);
    threadData->lastEquationSolved = 20;
  }
}
/* for continuous time variables */
int simpleCircuitEqns_functionAlgebraics(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_ALGEBRAICS);
#endif
  data->simulationInfo->callStatistics.functionAlgebraics++;

  simpleCircuitEqns_function_savePreSynchronous(data, threadData);
  
  functionAlg_system0(data, threadData);

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_ALGEBRAICS);
#endif

  TRACE_POP
  return 0;
}

#ifdef __cplusplus
}
#endif
