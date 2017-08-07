function plotTheoreticalMSD(t,type,values)
fMsd = theoreticalMSD(type,values);
plot(t,fMsd(t),'DisplayName',type);
end
     