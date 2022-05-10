model simpleCircuitEqns
  Real u,u1,u3,u4;
  Real u2(start=1);
  Real i,i1,i2;
  parameter Real A = 12,f = 1,R1 = 10,R2 = 100,C = 1,L = 0.1;
  final constant Real pi = 3.141592654;

initial equation
  //u2 = 1.0;
  der(u2) = 0.0;
  der(i2) = 0.0;
  
equation
  assert(u == i,"Ein ASSERT!",level = AssertionLevel.warning);
  u = A * sin(2 * pi * f * time);
  u1 + u2 = u;
  u3 + u4 = u;
  i1 + i2 = i;
  u1 = R1 * i1;
  u3 = R2 * i2;
  C * der(u2) = i1;
  L * der(i2) = u4;
end simpleCircuitEqns;

