function [dx]=impl_Euler_schritt(t,x,dt,f)
% BB, 2018-05-15
%
% [dx]=impl_Euler_schritt(t,x,dt,f)
%
% Berechnung eines impliziten Euler-Schritts
% 
% Input-Variablen::
%   t   = aktueller Zeitpunkt
%   x   = Zustand zum aktuellen Zeitpunkt
%   dt  = Schrittweite der Integration
%   f   = rechte Seite der DGL
%
% Output-Variablen::
%   dx  = relative Änderung der Zustände bzgl. dt
global k1 options;
if isempty(k1)
  k1 = zeros(length(x),1);
  options = optimset(optimset('fsolve'),'Display','none');
end
k1 = fsolve(@residuum,k1,options,t,x,dt,f);
dx = k1;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Residuum-Berechnung für das Nichtlineare Gleichungssystem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [res]=residuum(k1,t,x,dt,f)
   res = k1 - f( t + dt, x + dt*k1);
return;