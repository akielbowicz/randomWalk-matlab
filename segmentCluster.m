%% Segmentacion de caminatas
% generamos una estructura en la que estan los segmentos dada una caminata
function [seg, varargout] = segmentCluster(walkIn,varargin)
%Funcion para segmentar una caminata toma como argumento una caminata y
%devuelve una cell con con las posiciones de los segmentos para cada
%longitud de segmento.
%Se puede dar como argumentos extra dando el nombre seguido  del valor
% 'DiffusionCoef'
% ' Probability'
% 'Radius'
% Tambien se puede pedir que genere un plot marcando los segmentos mientras
% los encuentra
% 'Plot'
% 'Histogram'


%Set defaults
D = sum(var(diff(walkIn),1),2)/2; % D
probability = 0.95;
rConf = 1;
plt = false;
htg = false;
h = [];
for i=1:numel(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case 'Radius' %asignamos
                rConf = varargin{i+1};
            case 'DiffusionCoef' %asignamos
                D = varargin{i+1};
            case 'Probability' %asignamos
                probability = varargin{i+1};
            case 'Plot'
                plt = true;
            case 'Histogram'
                htg = true;
        end
    end
    
end %i varargin

threshold = (0.236 - log(1-probability))/(2.325) ; % dada por la ec de Saxton
%%
%Para separar ingresamos el numero de pasos que tenemos en cuenta y el
%radio de confinamiento

fooSegment = cell(1,2);
fooSegment{1,1} = 2;
positionIndex = 1;
% figure
while positionIndex < length(walkIn)-1
    foo = true;
    rangeIndex = 3;
    while foo && (positionIndex+rangeIndex+1 < length(walkIn))
        
        radiusSquared = max(sum((walkIn(positionIndex:positionIndex+rangeIndex,:)-walkIn(positionIndex*ones(rangeIndex+1,1),:)).^2,2));
        
        foo = ((D*rangeIndex/radiusSquared) > threshold);
        
        rangeIndex = rangeIndex+1;
    end %j n_rang
    
    if rangeIndex>2
        ind = ([fooSegment{:,1}] == rangeIndex-1);
        
        if any(ind)
            fooSegment{ind,2} = [fooSegment{ind,2} positionIndex];
        else
            fooSegment{end+1,1} = rangeIndex-1;
            fooSegment{end,2} = positionIndex;
        end
        
    end
    positionIndex = positionIndex+rangeIndex;
    
end %i numel caminata

[ ~ , ind] = sort([fooSegment{:,1}]);
seg = fooSegment(ind,:);
%%
try
    if plt
        figure('Units', 'in',...
            'PaperSize',[5 5],...
            'Resize', 'off',...%             'Color', 'none',...
            'Position', [1 1 5 5])
        for i=1:numel([seg{:,1}])
            clf
            plot(walkIn(:,1),walkIn(:,2),'.-')
            hold on
            for j =1:numel(seg{i,2})
                
                plot(walkIn(seg{i,2}(j):seg{i,2}(j)+seg{i,1},1),...
                    walkIn(seg{i,2}(j):seg{i,2}(j)+seg{i,1},2),...
                    '.-r','LineWidth',2)
                
                plot(walkIn(seg{i,2}(j),1),walkIn(seg{i,2}(j),2),...
                    '*k','MarkerSize',4)
            end
            title(['Cúmulos de ' num2str(seg{i,1}) ' pasos'])
            xlabel('x ( nm )');
            ylabel('y ( nm )');
            legend('off');
            formatFigure()
            drawnow
            pause(1)
            
        end
    end
    
    if htg
        h = zeros(size(seg));
        h(:,1) = [seg{:,1}];
        for i = 1:length(seg)
            h(i,2) = numel(seg{i,2});
        end
        figure
        bar(h(:,1),h(:,2))
    end
    
    % nout = numel(varargout);
    if nargout > 1
        if htg
            varargout{1} = h;
        else
            h = zeros(size(seg));
            h(:,1) = [seg{:,1}];
            for i = 1:length(seg)
                h(i,2) = numel(seg{i,2});
            end
            varargout{1} = h;
        end
    end
catch
    
    if nargout > 1
        if htg
            varargout{1} = h;
        else
            disp('Nothing to return')
        end
    end
end

