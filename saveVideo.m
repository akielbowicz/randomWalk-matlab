function saveVideo(randomWalk,tau,filepath)
clear videoFile

videoFile = VideoWriter(filepath,'Motion JPEG AVI');

open(videoFile);


fig =   figure('Units', 'pixels',...
            'PaperSize',[600 600],...
            'Resize', 'off',...
            'Color', 'w',...
            'Position', [10 10 600 600]);
plot(randomWalk(:,1), randomWalk(:,2))
ax=axis;

for iSteps=1:length(randomWalk)
    clf
    hold on
    plot(randomWalk(1:iSteps,1), randomWalk(1:iSteps,2) , ...
         '.-'         , ...
        'Color'           , [0.2148    0.4922    0.7188] ,...
        'LineWidth'       , 2          );
    
    plot(randomWalk(iSteps,1), randomWalk(iSteps,2), ...
        'LineStyle'       , 'none'         , ...
        'Marker'          , 'o'      , ...
        'MarkerSize'      , 8           , ...
        'MarkerEdgeColor' , [0.8906    0.1016    0.1094] , ...
        'MarkerFaceColor' , [0.8906    0.1016    0.1094] );
    
    hXLabel = xlabel('x ( nm )');
    hYLabel = ylabel('y ( nm )');
    hTitle = title(sprintf('T  = %g seg',tau*iSteps));
    hLegend = legend('off');
    
    
    % configurar ejes
    set([hXLabel, hYLabel,hTitle], ...
        'FontName'   , 'AvantGarde',...
        'FontSize'   , 32   , ...
        'FontWeight' , 'demi');

    
    set(gca, ...
        'FontName'   , 'Helvetica' , ...
        'PlotBoxAspectRatio' , [1 1 1],...
        'Box'         , 'on'     , ...
        'TickDir'     , 'out'     , ...
        'TickLength'  , [.02 .02] , ...
        'XMinorTick'  , 'on'      , ...
        'YMinorTick'  , 'on'      , ...
        'XGrid'        , 'on'    , ...
        'YGrid'        , 'on'    , ...
        'XColor'      , 2*[0.1 0.1 0.1], ...
        'YColor'      , 2*[0.1 0.1 0.1], ...
        'LineWidth'   , 1.5         , ...
        'FontWeight'  , 'normal'     ,...
        'FontSize'    , 20    );
    
    axis(ax)
    drawnow
    frame = getframe(fig);
    
    writeVideo(videoFile,frame);
    
end%iSteps
close(videoFile);