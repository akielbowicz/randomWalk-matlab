function out = randomWalkDistribution(nStep,varargin)
% RANDOMWALKDISTRIBUTION Generador de caminatas de pasos una dada
% distribucion

% W = RANDOMWALKDISTRIBUTION(N) caminata de N pasos en dos dimensiones. Con
% com pasos distribuidos uniformemente entre [-sqrt(3),sqrt(3)], de manera que tiene varianza 1.
% W = RANDOMWALKDISTRIBUTION( _ ,'Distribucion',obj.dist) 
% La distribucion de los pasos se puede dar como un objeto distribucion de Matlab.
% W = RANDOMWALKDISTRIBUTION( _ ,'Normal',{'mu',2,'sigma',1}) 
%O se pueden dar los parametros de la distribucion en una celda
% W = RANDOMWALKDISTRIBUTION( _ ,'Dimension',DIM) caminata en DIM dimensiones
% Todas las caminatas parten del origen (0,..,0), por lo que W tiene longitud N+1
% donde N es el numero de pasos


%Defaults
nDimension = 2;
useDistribution = 0;
meanStep = 0;
stdStep = 1;

if numel(varargin)>0
    meanStep = 0;
    stdStep = 1;
    for i=1:numel(varargin)
        if ischar(varargin{i})
            switch varargin{i}
                
                case 'Dimension'
                    nDimension = varargin{i+1};
                    continue
                case 'Mean'
                    meanStep = varargin{i+1};
                    continue
                case 'Deviation'
                    stdStep = varargin{i+1};
                    continue
                case 'Distribution'
                    try
                        if ischar(varargin{i+1})
                            useDistribution = 1;
                            try
                                distribution = makedist(varargin{i+1},varargin{i+2}{:});
                            catch
                                distribution = makedist(varargin{i+1});
                            end
                        else
                            distribution = varargin{i+1};
                        end%if
                    end%try
                otherwise
                    error('Parametro no valido')
            end%switch
        end%if
    end%for i
    
end%if

if verLessThan('matlab','8.1')
    randomStep = meanStep + sqrt(3)*stdStep*(2*rand(nStep,nDimension)-1);
    disp('Matlab version less than 8.1, I used rand(-) to generate the numbers')
else
    
    if not(useDistribution)
        randomStep = meanStep + sqrt(3)*stdStep*(2*rand(nStep,nDimension)-1);
    else
        
        randomStep = distribution.random(nStep,nDimension);
    end %if useDist
end %if version

out = [zeros(1,nDimension);cumsum(randomStep)];
