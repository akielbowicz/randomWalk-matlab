function varargout = plotScatter(walk,varargin)
% agregar comentarios
% bug 1 revisar el tamano valor y los indices de los outliers
% Falta agrefgar la posibilidad de utilizar otros test, adtest,jbtest...
plotGaussian = false;
showData = true;
excludeOutliers = false;
nSigmaOutlier = 3;

plotWalk = false;

if nargin > 1
for i = 1:numel(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case 'PlotGaussian'
                plotGaussian = true;
                continue
            case 'ShowData'
                if strcmpi(varargin{i+1},'on')
                    showData = true;
                elseif strcmpi(varargin{i+1},'off')
                    showData = false;
                end
                continue
            case 'Outliers'
                if strcmpi(varargin{i+1},'Exclude')
                excludeOutliers = true;
                end
                continue
            case 'PlotWalk'
                plotWalk = true;
                continue
            case 'SigmaOutlier'
                if isnumeric(varargin{i+1})
                nSigmaOutlier = varargin{i+1};
                else
                    error('Umbral de outliers no valido')
                end
            otherwise
                if ~any([strcmpi(varargin{i},'Exclude'),...
                        strcmpi(varargin{i},'on'),...
                        strcmpi(varargin{i},'off')])
                error(['Parametro no válido: ' varargin{i}])
                end
        end
    end
end
end
fig = figure('Units', 'in',...
    'PaperSize',[5 5],...
    'Resize', 'off',...    'Color', 'none',...
    'Position', [1 1 5 5]);

colores = qualitativo(9);

step= diff(walk);
[stepAngle , stepLength] = cart2pol(step(:,1),step(:,2));

angles = linspace(0,2*pi,100);
lengths = ones(length(angles),1);


sigmaStep = sqrt(sum(var(step(:,1:2))));
if excludeOutliers
    isOutlier = stepLength > nSigmaOutlier*sigmaStep;
    stepAngle(isOutlier) = []; 
    stepLength(isOutlier) = [];
    step(isOutlier,:) = [];
end

hPolar = polaraxes('parent',fig,...
    'Position',[0.35 0.1 0.55 0.55]);
hXHist = axes('parent',fig,...
    'Position',[0.35 0.72 0.55 0.24]);
hYHist = axes('parent',fig,...
    'Position',[0.03 0.1 0.24 0.55]);

hold(hPolar,'on')
polarplot(hPolar,stepAngle,stepLength,...
    'LineStyle', 'none',...
    'Color', colores(2,:),...
    'Marker', '.');

colorSigma = colores([3,5,1],:);

for iSigma = 1:3
polarplot(hPolar,angles,iSigma*sigmaStep*lengths,...
    'LineStyle', '-',...
    'LineWidth', 1.5,...
    'Color', colorSigma(iSigma,:),...
    'Marker', 'none')
end

indexOutliers = (stepLength > nSigmaOutlier*sigmaStep);

polarplot(hPolar,stepAngle(indexOutliers),stepLength(indexOutliers),...
    'LineStyle', 'none',...
    'LineWidth', 2,...
    'Color', colores(1,:),...
    'Marker', 'x',...
    'MarkerSize',6)
[m_angle,m_length] = cart2pol(mean(step(:,1)),mean(step(:,2)));
polarplot(hPolar,[0 m_angle],[0 m_length],...
    '.',...
    'MarkerSize',8,...
    'Color', colores(4,:))

hold(hPolar,'off')
title (hPolar,'');
legend(hPolar,'off',...
    'location', 'best' );

rLim = hPolar.RLim(2);

histogram(hXHist,step(:,1),'Normalization','pdf','BinMethod','scott')
histogram(hYHist,step(:,2),'Normalization','pdf','BinMethod','scott')

if plotGaussian
t = linspace(-rLim,rLim,50);
hold(hXHist,'on')
pdX = makedist('Normal',mean(step(:,1)),std(step(:,1)));
plot(hXHist,t,pdf(pdX,t),'-r','LineWidth',1)
hold(hXHist,'off')

hold(hYHist,'on')
pdY = makedist('Normal',mean(step(:,2)),std(step(:,2)));
plot(hYHist,t,pdf(pdY,t),'-r','LineWidth',1)
hold(hYHist,'off')
end

set(hYHist,'View', [270 90],...
    'XAxisLocation','top')

set([hXHist,hYHist],'XLim',[-rLim rLim],...
    'XMinorTick'  , 'on'      , ...
    'YMinorTick'  , 'on'      , ...
    'XGrid'        , 'on'    , ...
    'YGrid'        , 'on'    , ...
    'XColor'      , 3*[.1 .1 .1], ...
    'YColor'      , 3*[.1 .1 .1],...
    'YTickLabel',{},...
    'XTickLabel',{});

if showData
dim = [0.03 .72 .31 .24];
str = sprintf(['\\mu_{x} = %+.2g    \\sigma_{x} = %.2g \n' ...
               '\\mu_{y} = %+.2g    \\sigma_{y} = %.2g \n'...
               '\\rho_{xy} = %.2g  \n'...
               'isGaussian_{x} = %d \nisGaussian_{y} = %d'],...
               mean(step(:,1)),std(step(:,1)),...
               mean(step(:,2)),std(step(:,2)),...
               corr(step(:,1),step(:,2)),...
               ~lillietest(step(:,1)),~lillietest(step(:,2)));
annotation('textbox',dim,'String',str,...
    'LineStyle','none','FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);
end

if plotWalk
   figWalk = figure;
    axWalk = gca;
    hold all 
    step = diff(walk);
    [~, stepLength] = cart2pol(step(:,1),step(:,2));
    isOutlier =  stepLength > nSigmaOutlier*sigmaStep;
    if size(walk,2)==2
   plot(axWalk,walk(:,1),walk(:,2),'-')
     quiver(axWalk,walk([isOutlier;false],1),walk([isOutlier;false],2),...
       step(isOutlier,1),step(isOutlier,2),'AutoScale','off',...
       'LineWidth',1.5,...
       'Color','r',...
       'MaxHeadSize',0.05)
    elseif size(walk,2)==3
         plot3(axWalk,walk(:,1),walk(:,2),walk(:,3),'-')
   quiver3(axWalk,walk([isOutlier;false],1),...
                  walk([isOutlier;false],2),...
                  walk([isOutlier;false],3),...
       step(isOutlier,1),step(isOutlier,2),...
       step(isOutlier,3),'AutoScale','off',...
       'LineWidth',1.5,'Color','r','MaxHeadSize',0.05)  
    end
   xlabel('x ( nm )') 
   ylabel('y ( nm )') 
   zlabel('z ( nm )') 
   formatFigure(figWalk)
end


if nargout > 0
    varargout{1} = fig;
end