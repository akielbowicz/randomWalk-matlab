function out = randomWalkConfined(nStep,rConfinment,varargin)
% RANDOMWALKCONFINED Generador de caminatas confinadas

% W = RANDOMWALKCONFINED(N,R) caminata de N pasos en dos dimensiones. Con
% con confinamiento dado en un circulo de radio R
% W = RANDOMWALKCONFINED( _ ,'StepLength',L) L es la longitud media del
% paso. El valor predeterminado es 1
% W = RANDOMWALKCONFINED( _ ,'Norm',NORM) define la norma con la que se
% quiere definir el confinamiento. NORM puede ser un numero entero p o
% 'inf'
% W = RANDOMWALKCONFINED( _ ,'StepType',TYPE) TYPE define la distribucion
% de los pasos, puede ser 'gaussian' o 'uniform'. Los pasos van a tener
% valor medio 0 y desviacion estandar dada por L('StepLength') que esta 
%predeterminada en 1.
% W = RANDOMWALKCONFINED( _ ,'Dimension',DIM) caminata en DIM
% dimensiones. DIM puede ser 1 o 2;
% Todas las caminatas parten del origen (0,0), por lo que W tiene longitud N+1
% donde N es el numero de pasos
%Set defaults

nDimension = 2;
lengthStep = 1;
stepType = 'gaussian';
norma = @(x) sqrt(sum(x.^2,2));

if numel(varargin)>0
    for i = 1:numel(varargin)
        if ischar(varargin{i})
            switch varargin{i}
                
                case 'Dimension'
                    nDimension = varargin{i+1};
                    continue
                case 'StepLength'
                    lengthStep = varargin{i+1};
                    continue
                case 'Norm'
                    type_norm = varargin{i+1};
                    if strcmp(type_norm,'inf') %'cuadrado'
                        norma = @(x) max(abs(x));
                    elseif type_norm == 1 %'rombo'
                        norma = @(x) sum(abs(x));
                    else
                        p = type_norm;
                        norma = @(x) sum(abs(x).^p)^(1/p);
                    end%if
                    continue
                case 'StepType'
                    if strcmpi(varargin{i+1} ,'gaussian')
                        stepType = 'gaussian';
                    elseif strcmpi(varargin{i+1},'uniform')
                        stepType = 'uniform';
                    else
                        error('Bad step type')
                    end
                    continue
                otherwise
                    error('Parametro no valido')
            end%switch
        end%if ischar
    end %for i
end%if n vararg

out = zeros(nStep+1,nDimension);

if strcmpi(stepType,'gaussian')
    steps = lengthStep*(randn(nStep+1,nDimension));
elseif strcmpi(stepType,'uniform')
    steps = sqrt(3)*lengthStep*(2*rand(nStep+1,nDimension)-1);
end

x_i = zeros(1,nDimension);
for i = 2:nStep+1
    x_i = x_i + steps(i,:);
    normaPosition =  norma(x_i);
    if normaPosition < rConfinment
        out(i,:) = x_i;
    else
        x_try = x_i - steps(i,:);
        step_try = rand(1,nDimension);
        while norma(x_try + step_try) > rConfinment
            step_try = 2*rand(1,nDimension)-1;
        end
        x_i = x_try + step_try;
        out(i,:) = x_i;
    end
end
