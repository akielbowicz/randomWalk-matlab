%% Segmentacion de caminatas
% generamos una estructura en la que estan los segmentos dada una caminata
function [seg, varargout] = segmentThread(caminata_in,varargin)
% segmentacion_j divide la caminata basandose en el criterio del angulo de
% giro de los pasos, y se puede considerar distinto numero de pasos de giro
% segmentacion_j(caminata,'Value')
% 'Value' puede ser 'Angulo', 'Plot'
% Los valores predeterminados son $Angulo = 90^o$
% Los angulos tienen que estar en DEG'
ang = 90;
plt = false;
htg = false;
h = [];
for i=1:numel(varargin)
    
    switch varargin{i}
        case 'Angle' %asignamos
            ang = varargin{i+1};
        case 'Plot'
            plt = true;
        case 'Histogram'
            htg = true;
    end
    
end %i varargin

%%
%Para separar ingresamos el numero de pasos que tenemos en cuenta y el
%[angulo que usamos de
seg_foo = cell(1,2);
seg_foo{1,1} = 2;
ind_pos = 1;

while ind_pos < numel(caminata_in(:,1))-1
    foo = true;
    ind_rang = 1;
    
    while foo && (ind_pos+ind_rang+1 < length(caminata_in))
        x = diff(caminata_in(ind_pos+ind_rang-1:ind_pos+ind_rang,:));
        y = diff(caminata_in(ind_pos+ind_rang:ind_pos+ind_rang+1,:));
        
        costht = dot(x,y)/sqrt(dot(x,x)*dot(y,y));
        foo = (costht > cos(ang*pi/180));
        
        
        ind_rang = ind_rang+1;
    end %j n_rang
    
    if ind_rang>2
        ind = [seg_foo{:,1}]==ind_rang-1;
        if any(ind)
            seg_foo{ind,2} = [seg_foo{ind,2} ind_pos];
        else
            seg_foo{end+1,1} = ind_rang-1;
            seg_foo{end,2} = ind_pos;
        end
        
    end
    ind_pos = ind_pos+ind_rang;
    
end %i numel caminata

% seg = cell(size(seg_foo));
[ ~ , ind] = sort([seg_foo{:,1}]);
seg = seg_foo(ind,:);
%%
try
    if plt
        figure('Units', 'in',...
            'PaperSize',[5 5],...
            'Resize', 'off',...%             'Color', 'none',...
            'Position', [1 1 5 5])
        for i=1:numel([seg{:,1}])
            clf
            plot(caminata_in(:,1),caminata_in(:,2),'.-')
            hold on
            for j =1:numel(seg{i,2})
               
                plot(caminata_in(seg{i,2}(j):seg{i,2}(j)+seg{i,1},1),...
                    caminata_in(seg{i,2}(j):seg{i,2}(j)+seg{i,1},2),...
                    '.-r','LineWidth',2)
                
                plot(caminata_in(seg{i,2}(j),1),caminata_in(seg{i,2}(j),2),...
                    '*k','MarkerSize',4)
                
            end
            title(['Filamentos de ' num2str(seg{i,1}) ' pasos'])
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

