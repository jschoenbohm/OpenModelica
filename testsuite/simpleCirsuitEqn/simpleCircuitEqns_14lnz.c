/* Linearization */
#include "simpleCircuitEqns_model.h"
#if defined(__cplusplus)
extern "C" {
#endif
const char *simpleCircuitEqns_linear_model_frame()
{
  return "model linearized_model \"simpleCircuitEqns\" \n  parameter Integer n = 2 \"number of states\";\n  parameter Integer m = 0 \"number of inputs\";\n  parameter Integer p = 0 \"number of outputs\";\n"
  "  parameter Real x0[n] = %s;\n"
  "  parameter Real u0[m] = %s;\n"
  "\n"
  "  parameter Real A[n, n] =\n\t[%s];\n\n"
  "  parameter Real B[n, m] = zeros(n, m);%s\n\n"
  "  parameter Real C[p, n] = zeros(p, n);%s\n\n"
  "  parameter Real D[p, m] = zeros(p, m);%s\n\n"
  "\n"
  "  Real x[n](start=x0);\n"
  "  input Real u[m];\n"
  "  output Real y[p];\n"
  "\n"
  "  Real 'x_i2' = x[1];\n""  Real 'x_u2' = x[2];\n"
  "equation\n  der(x) = A * x + B * u;\n  y = C * x + D * u;\nend linearized_model;\n";
}
const char *simpleCircuitEqns_linear_model_datarecovery_frame()
{
  return "model linearized_model \"simpleCircuitEqns\" \n parameter Integer n = 2 \"number of states\";\n  parameter Integer m = 0 \"number of inputs\";\n  parameter Integer p = 0 \"number of outputs\";\n  parameter Integer nz = 7 \"data recovery variables\";\n"
  "  parameter Real x0[2] = %s;\n"
  "  parameter Real u0[0] = %s;\n"
  "  parameter Real z0[7] = %s;\n"
  "\n"
  "  parameter Real A[n, n] =\n\t[%s];\n\n"
  "  parameter Real B[n, m] = zeros(n, m);%s\n\n"
  "  parameter Real C[p, n] = zeros(p, n);%s\n\n"
  "  parameter Real D[p, m] = zeros(p, m);%s\n\n"
  "  parameter Real Cz[nz, n] =\n\t[%s];\n\n"
  "  parameter Real Dz[nz, m] = zeros(nz, m);%s\n\n"
  "\n"
  "  Real x[n](start=x0);\n"
  "  input Real u[m];\n"
  "  output Real y[p];\n"
  "  output Real z[nz];\n"
  "\n"
  "  Real 'x_i2' = x[1];\n""  Real 'x_u2' = x[2];\n"
  "  Real 'z_$cse1' = z[1];\n""  Real 'z_i' = z[2];\n""  Real 'z_i1' = z[3];\n""  Real 'z_u' = z[4];\n""  Real 'z_u1' = z[5];\n""  Real 'z_u3' = z[6];\n""  Real 'z_u4' = z[7];\n"
  "equation\n  der(x) = A * x + B * u;\n  y = C * x + D * u;\n  z = Cz * x + Dz * u;\nend linearized_model;\n";
}
#if defined(__cplusplus)
}
#endif

