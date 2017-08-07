function plotGMM2D(dataPoints,gmmFit)
figure('Units', 'in',...
    'PaperSize',[5 5],...
    'Resize', 'off',...    'Color', 'none',...
    'Position', [1 1 5 5])

scatter(dataPoints(:,1),dataPoints(:,2),10,'.')
hold on
nComponent = gmmFit.NumComponents;

ezcontour(@(x,y)pdf(gmmFit,[x y]),1.1*[min(dataPoints(:,1)) max(dataPoints(:,1)) min(dataPoints(:,2)) max(dataPoints(:,2))]);
hold off
posteriorProb = posterior(gmmFit,dataPoints);
formatFigure()

figure('Units', 'in',...
    'PaperSize',[5 5],...
    'Resize', 'off',...    'Color', 'none',...
    'Position', [1 1 5 5]);


for i =1:nComponent
si = subplot(1,nComponent,i);

scatter(dataPoints(:,1),dataPoints(:,2),10,posteriorProb(:,i))
a = get(si,'Position');
a(2) = 0.15 ; a(4) = 0.78;
set(si,'Position',a)
title(si,sprintf('Component %d Probability',i))
caxis([0 1])
end
colorbar('Position', [0.125 0.045 0.785 0.05],'Location','northoutside');
% formatFigure()


figure('Units', 'in',...
    'PaperSize',[5 5],...
    'Resize', 'off',...    'Color', 'none',...
    'Position', [1 1 5 5])

idx = cluster(gmmFit,dataPoints);
hold on
for i = 1:nComponent
cluster1 = dataPoints(idx == i,:);
scatter(cluster1(:,1),cluster1(:,2),10,'+',...
    'DisplayName',sprintf('Cluster %d',i));
end

title('')
hold off
formatFigure()
legend('Location','best')