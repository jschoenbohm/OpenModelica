function [t,x] = experiment_ESV_FS(phi,f,t_0,t_e,dt)
% BB, 2018-04-23
%
% [t,x] = experiment_ESV_FS(phi,f,t_0,t_e,dt)
%
% Experiment-Umgebung für Einschrittverfahren mit fixer Schrittweite
% Input-Variablen:
%   phi      = Funktion zur Berechnung eines Integrationsschritts
%   f        = Modell-Funktion (rechte Seite)
%   t_0      = Anfangszeitpunkt der Simulation
%   t_e      = Endzeitpunkt der Simulation 
%   dt       = Schrittweite der Integration
%
% Output-Variablen::
%   t        = Zeitpunkte der Simulation
%   x        = Zustände an den entsprechenden Zeitpunkten

% Zeitmessung - Anfang
tic

% Bestimmung der Anfangswerte
x_0 = f(t_0);

% Berechnung der Integration von t_0 bis t_e mit fester Schrittweite
[t,x] = ESV_FS(phi,f,x_0,t_0,t_e,dt);

% Zeitmessung - Ende
zeit=toc;

% Statistik-Ausgaben
disp(['Algorithmus:                Feste Schrittweite, ',func2str(phi)]);
disp(['Benötigte Zeit:             ',num2str(zeit)]);
disp(['Anzahl Schritte:            ',num2str((t_e-t_0)/dt)]);

% Löschen der globalen Variablen
clear global
end

