#if defined(__cplusplus)
  extern "C" {
#endif
  int simpleCircuitEqns_mayer(DATA* data, modelica_real** res, short*);
  int simpleCircuitEqns_lagrange(DATA* data, modelica_real** res, short *, short *);
  int simpleCircuitEqns_pickUpBoundsForInputsInOptimization(DATA* data, modelica_real* min, modelica_real* max, modelica_real*nominal, modelica_boolean *useNominal, char ** name, modelica_real * start, modelica_real * startTimeOpt);
  int simpleCircuitEqns_setInputData(DATA *data, const modelica_boolean file);
  int simpleCircuitEqns_getTimeGrid(DATA *data, modelica_integer * nsi, modelica_real**t);
#if defined(__cplusplus)
}
#endif