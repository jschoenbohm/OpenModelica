function [dx] = nmb_RLC_1(time, x)
  % Berechnung der Ableitung im Punkt (t, x)
  %
  % NN, 20xx-yy-zz
  %
  % Input-Variablen:
  %   time   = aktuelle Zeit
  %   x      = Werte der Zustaende zum Zeitpunkt t
  %
  % Output-Variablen:
  %   dx_dt = Ableitungen der Zustaende zum Zeitpunkt t

  % globale Variablen
  global z;
  % Bestimmung der Anfangswerte
  if nargin==1
	dx = [ 0; 0];
  else
	if any(size(z) ~= [0, 0])
		z = zeros(0, 0);
	end

  % Parameter des Modells
  R1_R = 1.0;
  R1_T_ref = 300.15;
  R1_alpha = 0.0;
  R1_useHeatPort = false;
  R1_T = R1_T_ref;
  C_C = 1e-06;
  I_L = 100.0;
  SinV_V = 10.0;
  SinV_phase = 0.0;
  SinV_f = 10.0;
  SinV_signalSource_amplitude = SinV_V;
  SinV_signalSource_f = SinV_f;
  SinV_signalSource_phase = SinV_phase;
  SinV_offset = 0.0;
  SinV_startTime = 0.0;
  SinV_signalSource_offset = SinV_offset;
  SinV_signalSource_startTime = SinV_startTime;
  % Kopieren der Zustände in die entsprechenden Modellvariablen
  I_i = x(1);
  C_v = x(2);
  % Berechnung der Ableitungen im Punkt (t,x)
  SinV_signalSource_y = ( SinV_signalSource_offset + ( SinV_signalSource_amplitude .* sin(( ( ( 6.283185307179586 .* SinV_signalSource_f ) .* ( time - SinV_signalSource_startTime ) ) + SinV_signalSource_phase )) ) );
  SinV_v = SinV_signalSource_y;
  ground_p_v = 0.0;
  C_n_v = ground_p_v;
  SinV_p_v = C_n_v;
  SinV_n_v = ( SinV_p_v - SinV_v );
  I_p_v = SinV_n_v;
  I_p_i = I_i;
  I_n_i = ( -I_p_i);
  R1_p_i = ( -I_n_i);
  R1_i = R1_p_i;
  R1_T_heatPort = R1_T;
  R1_R_actual = ( R1_R .* ( 1.0 + ( R1_alpha .* ( R1_T_heatPort - R1_T_ref ) ) ) );
  R1_v = ( R1_R_actual .* R1_i );
  C_p_v = ( -( -1.0 .* ( C_n_v + C_v ) ));
  R1_n_v = C_p_v;
  R1_p_v = ( -( -1.0 .* ( R1_n_v + R1_v ) ));
  I_n_v = R1_p_v;
  I_v = ( I_p_v - I_n_v );
  der_I_i = ( -( I_v ./ ( -I_L) ));
  SinV_n_i = ( -I_p_i);
  SinV_p_i = ( -SinV_n_i);
  SinV_i = SinV_p_i;
  R1_n_i = ( -R1_p_i);
  C_p_i = ( -R1_n_i);
  C_i = C_p_i;
  C_n_i = ( -C_p_i);
  R1_LossPower = ( R1_v .* R1_i );
  ground_p_i = ( -( SinV_p_i + C_n_i ));
  der_C_v = ( -( ( -C_i) ./ C_C ));

  % Rückgabe der Ableitungen der Zustände
	dx = [ der_I_i; der_C_v];
  end
end

                                                            