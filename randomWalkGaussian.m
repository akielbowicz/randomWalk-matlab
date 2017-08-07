function out = randomWalkGaussian(nStep,meanStep,stdStep,varargin)
% RANDOMWALKGAUSSIAN Generador de caminatas de pasos con distribucion
% Gaussiana.

% W = RANDOMWALKGAUSSIAN(N) caminata de N pasos en dos dimensiones. Con
% pasos con distribucion Norm(0,1)
% W = RANDOMWALKGAUSSIAN(N,MEAN,STD) caminata de N pasos en dos dimensiones. Con
% pasos con distribucion Norm(MEAN,STD) en dos dimensiones
% W = RANDOMWALKGAUSSIAN(N,MEAN,STD,'Dimension',DIM) caminata de N pasos en dos dimensiones. Con
% pasos con distribucion Norm(MEAN,STD) en DIM dimensiones
% Todas las caminatas parten del origen (0,..,0), por lo que W tiene longitud N+1
% donde N es el numero de pasos

%Defaults
nDimension = 2;
if nargin < 2
meanStep = 0;
stdStep = 1;
end

if numel(varargin)>0

	for i=1:numel(varargin)
		if strcmpi(varargin{i},'Dimension')
				nDimension = varargin{i+1};
                break
		end
	end

end

randomStep = meanStep(ones(nStep,nDimension)) + stdStep*randn(nStep,nDimension);
out = [zeros(1,nDimension);cumsum(randomStep)];
