function out = randomWalkCorrelated(nStep,varargin)
% RANDOMWALKCORRELATED Generador de caminatas con pasos correlacionados

% W = RANDOMWALKCORRELATED(N) caminata de N pasos en dos dimensiones. Con
% con distribucion de los angulos de giro centrada en 0 y angulo de giro
% maximo de PI/2 radianes.
% W = RANDOMWALKCORRELATED( _ ,'MeanAngle',ANGLE) ANGLE es el valor medio
% de los angulos de giro ( EN RADIANES ) ... 180 grad = PI rad
% W = RANDOMWALKCORRELATED( _ ,'MaxAngle',ANGLE) ANGLE es el valor maximo
% que puede girar un paso. ( EN RADIANES )
% W = RANDOMWALKCORRELATED( _ ,'Lattice',LAT) Genera caminata en un
% lattice. LAT puede ser los numeros {3,4,6} o las palabras
% equivalente {'triangular','square','honeycomb','hexagonal'} 
% W = RANDOMWALKCORRELATED( _ ,'Dimension',DIM) caminata en DIM
% dimensiones. DIM puede ser 1 o 2;
% Todas las caminatas parten del origen (0,0), por lo que W tiene longitud N+1
% donde N es el numero de pasos

%Set default
nDimension = 2;
meanAngleRadian = 0;
maxAngleRadian = pi/2;
useLattice = 0;

if numel(varargin)>0
    for i = 1:numel(varargin)
        if ischar(varargin{i})
            
            switch varargin{i}
                case 'MeanAngle'
                    meanAngleRadian = varargin{i+1};
                    continue
                case 'MaxAngle'
                    maxAngleRadian = varargin{i+1};
                    continue
                case 'Dimension'
                    nDimension = varargin{i+1};
                    continue
                case 'Lattice'
                    if varargin{i+1} == 3 || varargin{i+1} == 6  || varargin{i+1} == 4
                        typeLattice = varargin{i+1};
                        useLattice = 1;
                    elseif strcmpi(varargin{i+1},'triangular')
                        typeLattice = 3;
                        useLattice = 1;
                    elseif strcmpi(varargin{i+1},'honeycomb') || strcmpi(varargin{i+1},'hexagonal')
                        typeLattice = 6;
                        useLattice = 1;
                    elseif strcmpi(varargin{i+1},'square')
                        typeLattice = 4;
                        useLattice = 1;
                    else
                        disp('No valid lattice argument')
                    end
                    continue
                otherwise
                    error('Parametro no valido')
            end%switch
        end%if ischar
    end%for i
end%if

if useLattice == 0
    randomAngle = maxAngleRadian*(2*rand(nStep,1)-1)+meanAngleRadian;
    
    if nDimension == 1
        step = cos(cumsum(randomAngle));
    elseif nDimension == 2
        step = [cos(cumsum(randomAngle)) sin(cumsum(randomAngle))];
    else
        disp('Too much space to turn, dimension must be less than 2')
    end
    
elseif useLattice ==1 && typeLattice == 3
    % Triangulos
    randomAngle = randi(6,nStep,1);
    step = [cos(2*pi*randomAngle/6) sin(2*pi*randomAngle/6)];
elseif useLattice ==1 && typeLattice == 4
    % Cuadrados
    randomAngle = randi(4,nStep,1);
    step = [cos(2*pi*randomAngle/4) sin(2*pi*randomAngle/4)];
elseif useLattice ==1 && typeLattice == 6
    % Hexagonos/panal de abeja
    randomAngle = cumsum(2*randi(3,nStep,1)-1);
    step = [cos(2*pi*randomAngle/6) sin(2*pi*randomAngle/6)];
else
    disp('Something is not right')
end

out =[zeros(1,nDimension); cumsum(step)];

