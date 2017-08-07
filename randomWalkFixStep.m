function out = randomWalkFixStep(nStep,varargin)
% RANDOMWALKFIXSTEP Generador de caminatas con paso de longitud constante.

% W = RANDOMWALKFIXSTEP(N) caminata de N pasos en dos dimensiones. Con
% pasos de longitud 1
% W = RANDOMWALKFIXSTEP( _ ,'StepLength',L) donde la longitud de los pasos
% es L.
% W = RANDOMWALKFIXSTEP( _ ,'Drift',V) donde V es el vector de deriva o el
% valor medio de los pasos.
% W = RANDOMWALKFIXSTEP( _ ,'Dimension',DIM) caminata en DIM dimensiones
% Todas las caminatas parten del origen (0,..,0), por lo que W tiene longitud N+1
% donde N es el numero de pasos

%Default dimension
nDimension = 2;
lengthStep = 1;
meanStep = zeros(1,nDimension);

if numel(varargin) > 0
    for i=1:numel(nargin)
        if ischar(varargin{i})
            switch varargin{i}
                case 'Dimension'
                    nDimension = varargin{i+1};
                    meanStep = zeros(1,nDimension);
                    continue
                case 'StepLength'
                    lengthStep = varargin{i+1};
                    continue
                case 'Drift'
                    meanStep = varargin{i+1};
                    nDimension = length(meanStep);
                    continue
                otherwise
                    error('Parametro no valido')
            end%switch
        end%if char
    end%for
end%if

if nDimension == 2
    
    randomAngle = 2*pi*rand(nStep,1);
    randomStep = lengthStep*[cos(randomAngle) sin(randomAngle)] ;
    %Agrego el drift si lo hubiese
    randomStep = randomStep + meanStep(ones(nStep,1),:);
    
    out =[zeros(1,nDimension); cumsum(randomStep)];
    
else
    
    randomStep = 2*rand(nStep,nDimension)-1;
    normStep = sqrt(sum(randomStep.^2,2));
    %Normalizo los pasos
    randomStep = randomStep./normStep(:,ones(nDimension,1));
    
    %Agrego el drift si lo hubiese
    randomStep = randomStep + meanStep(ones(nStep,1),:);
    %Genero la caminata
    out =[zeros(1,nDimension); cumsum(randomStep)];
end %nDimension
