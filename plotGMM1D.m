function [] = plotGMM1D(dataPoints,gmmFit)
colores = qualitativo(9);

nComponent = gmmFit.NumComponents;

figure
componentProp = gmmFit.ComponentProportion;

histogram(dataPoints,'Normalization','pdf','BinMethod','scott',...
    'LineWidth',1,'FaceColor',0.7*ones(3,1),...
    'DisplayName','Data Histogram');
xgrid = linspace(min(dataPoints),max(dataPoints),1001)';
hold on;
plot(xgrid,pdf(gmmFit,xgrid),'k-','LineWidth',2,...
    'DisplayName','Gmm distribution');

for iComp=1:nComponent
    distN = makedist('normal',gmmFit.mu(iComp),sqrt(gmmFit.Sigma(iComp)));
    plot(xgrid,componentProp(iComp)*pdf(distN,xgrid),'LineWidth',1.5,...
        'Color',colores(iComp,:),...
        'DisplayName',sprintf('Component %d',iComp))
end
hold off
formatFigure()
legend('location','best')

figure
posteriorProb = posterior(gmmFit,xgrid);
hold on
for iComp =1:nComponent

plot(xgrid,posteriorProb(:,iComp),...
    'Color',colores(iComp,:),...
    'LineWidth',1.5,...
    'DisplayName',sprintf('Component %d Probability',iComp))

end
hold off
axis([min(dataPoints) max(dataPoints) 0 1.05])
formatFigure()
legend('location','best')