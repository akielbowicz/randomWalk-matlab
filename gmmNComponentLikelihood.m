function [] = gmmNComponentLikelihood(points,nMaxComponents)
nRepeat = 10;
AIC = zeros(nRepeat,nMaxComponents);
BIC = zeros(nRepeat,nMaxComponents);
NLL = zeros(nRepeat,nMaxComponents);
convergedFlag = false(nRepeat,nMaxComponents);
for iComponent = 1:nMaxComponents
    for iRepeat = 1:nRepeat
        
        gmmfit = fitgmdist(points,iComponent);
        
        AIC(iRepeat,iComponent) = gmmfit.AIC;
        BIC(iRepeat,iComponent) = gmmfit.BIC;
        NLL(iRepeat,iComponent) = gmmfit.NegativeLogLikelihood;
        convergedFlag(iRepeat,iComponent) = gmmfit.Converged;
    end
end
%%
figure('Units', 'in',...
    'PaperSize',[5 5],...
    'Resize', 'off',...    'Color', 'none',...
    'Position', [1 1 5 5]);

s1 = subplot(3,1,1);
AICConverged = AIC;
AICNotConverged = AIC;
AICConverged(~convergedFlag) = nan;
AICNotConverged(convergedFlag) = nan;
[mAIC, imAIC] =  min(AICConverged(:));
[~,jMAIC] = ind2sub(size(AICConverged),imAIC);
hold(s1,'on')
plot(s1,[0 nMaxComponents+1],mAIC*ones(2,1),...
        '-','Color',0.3*ones(1,3))
plot(s1,(jMAIC)*ones(20,1),linspace(mAIC*0.98,max(AICConverged(:)),20),...
        '-','Color',0.3*ones(1,3))
plot(s1,1:nMaxComponents,AICConverged,'o',...
    'MarkerSize',4,...
    'LineWidth',1.5,...
    'Color',[0.2148    0.4922    0.7188])
pt = plot(s1,1:nMaxComponents,AICNotConverged,'x',...
    'MarkerSize',4,...
    'LineWidth',1,...
    'Color',[0.8906    0.1016    0.1094]);
legend(pt(1),sprintf('Método \nno convergió'),'Location','NorthEast')
hold(s1,'off')
ylabel(s1,'AIC')



s2 = subplot(3,1,2);
BICConverged = BIC;
BICNotConverged = BIC;
BICConverged(~convergedFlag) = nan;
BICNotConverged(convergedFlag) = nan;
[mBIC, imBIC] =  min(BICConverged(:));
[~,jMBIC] = ind2sub(size(BIC),imBIC);
hold(s2,'on')
plot(s2,[0 nMaxComponents+1],mBIC*ones(2,1),...
        '-','Color',0.3*ones(1,3))
plot(s2,(jMBIC)*ones(20,1),linspace(mBIC*0.98,max(BICConverged(:)),20),...
        '-','Color',0.3*ones(1,3))
plot(s2,1:nMaxComponents,BICConverged,'o',...
    'MarkerSize',4,...
    'LineWidth',1.5,...
    'Color',[0.3008    0.6836    0.2891])
plot(s2,1:nMaxComponents,BICNotConverged,'x',...
    'MarkerSize',4,...
    'LineWidth',1,...
    'Color',[0.8906    0.1016    0.1094])
hold(s2,'off')
ylabel(s2,'BIC')

s3 = subplot(3,1,3);

NLLConverged = NLL;
NLLNotConverged = NLL;
NLLConverged(~convergedFlag) = nan;
NLLNotConverged(convergedFlag) = nan;
[mNLL, imNLL] =  min(NLLConverged(:));
[~,jMNLL] = ind2sub(size(NLL),imNLL);

hold(s3,'on')
plot(s3,[0 nMaxComponents+1],mNLL*ones(2,1),...
        '-','Color',0.3*ones(1,3))
plot(s3,(jMNLL)*ones(20,1),linspace(mNLL*0.98,max(NLLConverged(:)),20),...
        '-','Color',0.3*ones(1,3))
plot(s3,1:nMaxComponents,NLLConverged,'o',...
    'MarkerSize',4,...
    'LineWidth',1.5,...
    'Color',[0.5938    0.3047    0.6367])
plot(s3,1:nMaxComponents,NLLNotConverged,'x',...
    'MarkerSize',4,...
    'LineWidth',1,...
    'Color',[0.8906    0.1016    0.1094])
hold(s3,'off')
ylabel(s3,'NegLogLikelihood')

set([s1,s2,s3],'XLim',[0,nMaxComponents+1],'XGrid','on',...
    'XTick',1:nMaxComponents)
set([s1,s2],'XTickLabel',{})
xlabel(s3,'Número  de componentes')
