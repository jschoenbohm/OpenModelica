function [t,x]=ESV_FS(phi, f, x_0, t_0, t_e, dt)
% BB, 2018-04-23
%
% [t,x]=ESV_FS(phi, f, x_0, t_0, t_e, dt)
%
% Integration mittels eines Einschrittverfahrens und
% fixer Schrittweite
%
% Input-Variablen:
%   phi      = Funktion zur Berechnung eines Integrationsschritts
%   f        = Modell-Funktion (rechte Seite)
%   x_0      = Anfangswerte der Zustände
%   t_0      = Anfangszeitpunkt der Simulation
%   t_e      = Endzeitpunkt der Simulation 
%   dt       = Schrittweite der Integration
%
% Output-Variablen::
%   t        = Zeitpunkte der Simulation
%   x        = Zustände an den entsprechenden Zeitpunkten


% Initialisierung des Zustandsvektors
  i = 1;
  t(1) = t_0;
  x(:,1) = x_0; % Definiert die Dimension (Anzahl der Zustände)

% Schleife mit expliziten Eulerschritten
	while t(i) < t_e
       dx = phi(t(i),x(:,i),dt,f);
       x(:,i+1) = x(:,i) + dt*dx;
       t(i+1) = min(t(i) + dt, t_e);
       i = i+1;
	end;

return;