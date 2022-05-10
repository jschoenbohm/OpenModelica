model RLC_1
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-56, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R = 1)  annotation(
    Placement(visible = true, transformation(origin = {-18, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Basic.Capacitor C(C = 1e-6, v(start = 0))  annotation(
    Placement(visible = true, transformation(origin = {-10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Inductor I(L = 100, i(start = 0))  annotation(
    Placement(visible = true, transformation(origin = {-18, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sources.SineVoltage SinV(V = 10, f = 10)  annotation(
    Placement(visible = true, transformation(origin = {-8, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(SinV.p, ground.p) annotation(
    Line(points = {{-18, -36}, {-56, -36}}, color = {0, 0, 255}));
  connect(C.n, ground.p) annotation(
    Line(points = {{-20, 50}, {-56, 50}, {-56, -36}}, color = {0, 0, 255}));
  connect(C.p, R1.n) annotation(
    Line(points = {{0, 50}, {27, 50}, {27, 34}, {-18, 34}}, color = {0, 0, 255}));
  connect(R1.p, I.n) annotation(
    Line(points = {{-18, 14}, {-18, 12}}, color = {0, 0, 255}));
  connect(I.p, SinV.n) annotation(
    Line(points = {{-18, -8}, {2, -8}, {2, -36}}, color = {0, 0, 255}));

annotation(
    uses(Modelica(version = "4.0.0")));
end RLC_1;
