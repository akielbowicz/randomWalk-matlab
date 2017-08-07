function plotMovie(randomWalk,tPause,varargin)
% PLOTMOVIE genera una pelicula del movimiento de la caminata
% PLOTMOVIE(WALK,T) Grafica la caminata WALK con tiempo entre pasos T
% PLOTMOVIE(_,'Start',t) Grafica la caminata desde el tiempo t
% PLOTMOVIE(_,'End',t) Grafica la caminata hasta el tiempo t
%%% bug 1 cuando se grafica con Start, empieza a graficar desde ese tiempo 
%%% pero incluye toda la parte previa.

nSteps = length(randomWalk); % duracion de la caminata
dim = min(size(randomWalk)); % dimensiones del movimiento

movieStart = 1;
movieEnd = nSteps;

if numel(varargin)>0
    for i=1:numel(varargin)
        if ischar(varargin{i})
            switch varargin{i}
                case 'Start'
                    movieStart = varargin{i+1};
                case 'End'
                    movieEnd = varargin{i+1}+1;
                otherwise
                    error('Parámetro no válido')
            end
        end
    end
end

x = randomWalk(:,1);
y = randomWalk(:,2);

if dim == 3
    z = randomWalk(:,3);
end


figure('Units', 'in',...
    'PaperSize',[5 5],...
    'Resize', 'off',...    'Color', 'none',...
    'Position', [1 1 5 5])

buttonH = uicontrol('Style', 'ToggleButton', ...
    'Units',    'in', ...
    'Position', [0.2, 4.2, 1, 0.42], ...
    'String',   'Pause', ...
    'FontSize', 14,...
    'FontWeight', 'bold',...
    'Value',    1);


for iStep = movieStart:movieEnd
    cla % limpio los ejes
       
    if dim == 2 %si es 2D
        
        plot(x(1:iStep),y(1:iStep),'.-',...
            'LineWidth',1.5)
        hold on
        plot(x(iStep),y(iStep),'.r',...
            'MarkerSize',16)
        plot(x(1),y(1),'ok',...
            'MarkerSize',6,'LineWidth',2)
        axis([min(x) max(x) min(y) max(y)])
        
    else
        
        plot3(x(1:iStep),y(1:iStep),z(1:iStep),'.-',...
            'LineWidth',1.5)
        plot3(x(1:iStep),y(1:iStep),min(z)*ones(1,iStep),'.-',...
            'LineWidth',1.5,...
            'Color',0.3*ones(1,3))
        hold on
        plot3(x(iStep),y(iStep),z(iStep),'.r',...
            'MarkerSize',16)
        plot3(x(iStep),y(iStep),min(z),'.k',...
            'MarkerSize',16)
        plot3(x(1),y(1),z(1),'ok',...
            'MarkerSize',6,'LineWidth',2)
        axis([min(x) max(x) min(y) max(y) min(z) max(z)])
        hZLabel = zlabel('z ( nm )');
        
    end
    
    hXLabel = xlabel('x ( nm )');
    hYLabel = ylabel('y ( nm )');
    
    
    hTitle = title(sprintf('T = %d', iStep-1));
    if dim == 2
        formatPlot(gca,hTitle,hXLabel, hYLabel)
    elseif dim == 3
        formatPlot(gca,hTitle,hXLabel, hYLabel,hZLabel)
    end
    
    drawnow
    pause(tPause)
    
    while get(buttonH, 'Value') == 0
        pause(0.1)
        
    end
    
end

end

function formatPlot(ax,hTitle,hXLabel, hYLabel,varargin)

if numel(varargin) == 0
    set([hTitle, hXLabel, hYLabel]  , ...
        'FontName'   , 'AvantGarde',...
        'FontSize'   , 12   , ...
        'FontWeight' , 'normal');
else
    hZLabel = varargin{1};
    set([hTitle,hXLabel, hYLabel,hZLabel]  , ...
        'FontName'   , 'AvantGarde',...
        'FontSize'   , 12   , ...
        'FontWeight' , 'normal');
    set(ax, ...
        'ZMinorTick'  , 'on'      , ...
        'ZGrid'        , 'on'    , ...
        'ZColor'      , 4*[.1 .1 .1]);
end

set( hTitle      , ...
    'FontWeight' , 'bold',...
    'Color'      , 1*[.1 .1 .1]);

set(ax, ...
    'PlotBoxAspectRatio' , [1 1 1],...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'LineWidth'   , 1         , ...
    'FontWeight'  , 'normal'     ,...
    'FontName'   , 'Helvetica' ,...
    'FontSize'    , 12     ,...
    'XMinorTick'  , 'on'      , ...
    'YMinorTick'  , 'on'      , ...
    'XGrid'        , 'on'    , ...
    'YGrid'        , 'on'    , ...
    'XColor'      , 3*[.1 .1 .1], ...
    'YColor'      , 3*[.1 .1 .1]);
end
