function [out,varargout] = msd(randomWalk,fraction)
%MSD   Mean Square Displacement/Desplazamiento cuadratico medio.
%  Y = MSD(WALK,FRACTION) es el MSD de la caminata WALK hasta un tiempo
%                      de retraso T = FRACTION x duracion de la caminata.
%                      WALK tiene que ser un vector de [Duracion x
%                      Dimensiones]
%  Y tiene su primera coordenada fijada a 0, corresponde al tiempo de
%  retraso T = 0. Tener en cuenta al graficar.
%  Si la FRACTION = 1, length(Y) = length(WALK) + 1; 
%  [Y, S ] = MSD(WALK,FRACTION) Y es el MSD y S es la varianza del MSD a
%  cada tiempo de retraso.

nStep = length(randomWalk); % duracion de la caminata
N = floor(nStep*fraction); % tiempo de retraso maximo

if N < 1
    error(['El valor de la fraccion es demasiado pequeño.' ...
    'El tiempo de retraso maximo es menor 1'])
else
   maxLag = N;
end

out = zeros(N,1); % inicializo el vector del msd



if nargout <= 1 % si solo que pide el msd
    
    for iLag = 1:maxLag
        % calculo del MSD para los distintos retrasos
        out(iLag) = mean(squareDisplacement(randomWalk,iLag-1));
    end
    
elseif nargout == 2 % si se pide el msd y la varianza
    
    vr = zeros(maxLag,1);
    for iLag = 1:maxLag
        vr(iLag) = var(squareDisplacement(randomWalk,iLag-1),1); % var(-,1) para 
                                                        % normalizar por N
        out(iLag) = mean(squareDisplacement(randomWalk,iLag-1));
    end
    
    vr(1) = vr(2); % asignamos la varianza del retraso 0 igual al
    varargout{1} = vr;
    
else  
    error('Hay demasiados argumentos de salida.')
end 

end


function out = squareDisplacement(randomWalk,tLag)
% Calcula la suma de los desplazamientos cuadraticos para un tiempo de
% retraso tLag en cada dimension y luego las suma. 
N = length(randomWalk);
out = sum((randomWalk(1:N-tLag,:) - randomWalk(1+tLag:N,:)).^2,2);
end
