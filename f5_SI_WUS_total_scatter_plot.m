% f5_SI_WUS_total_scatter_plot
figure,
iana=find(SNOTEL.Elev*0.3048>1500 );
iana=intersect(iana,site_select);
length(iana)
Insitu=Peak_SWE(iana,:);
%Insitu=Insitu_SWE(iana,:);
Reanalysis=Peak_SWE_re_post(iana,:);
Reanalysis_prior=Peak_SWE_re_prior(iana,:);
I=find(Insitu >0.01 & Reanalysis> 0.01  & isnan(Insitu)~=1 & isnan(Reanalysis)~=1 & isnan(Reanalysis_prior)~=1);
sum(isnan(Insitu(I))==0)
median(Insitu(I))
median(Reanalysis(I))
median(Reanalysis_prior(I))
%figure,set(gcf,'Position',[28 575 391 382])
%plot(Insitu(I),Reanalysis_prior(I),'o','color',[0.8500, 0.3250, 0.0980])
dscatter(Insitu(I),Reanalysis(I))
%mdl=fitlm(Insitu(I),Reanalysis(I),'intercept',false);
colormap(jet)
hold on
% plot(Insitu(I),Reanalysis(I),'o','color',[0, 0.4470, 0.7410])
plot([0,2.5],[0,2.5],'k','linewidth',1)
%figure
%reana=[repmat({'Pior'},length(I),1);repmat({'Posterrior'},length(I),1)];
%scatterhist([Insitu(I);Insitu(I)],[Reanalysis_prior(I);Reanalysis(I)],'group',reana,'Kernel','on')
R = corr(Insitu(I),Reanalysis(I))
MD = mean(Reanalysis(I) - Insitu(I))
RMSD = sqrt(mean((Insitu(I) - Reanalysis(I)).^2))
R2 = corr(Insitu(I),Reanalysis_prior(I))
MD2 = mean(Reanalysis_prior(I) - Insitu(I))
RMSD2 = sqrt(mean((Insitu(I) - Reanalysis_prior(I)).^2))
text(0.2,2.3,['R = ' num2str(R, '%.2f')],'FontSize',24)
text(0.2, 2.05,['MD = ' num2str(MD, '%.2f') ' m'],'FontSize',24)
text(0.2, 1.8,['RMSD = ' num2str(RMSD, '%.2f') ' m'],'FontSize',24)
grid off
xlabel('SNOTEL SWE (m)')
ylabel('Reanalysis SWE (m)')
set(gca,'FontSize',20)
title('WUS totsl','FontSize',28)
axis equal
box off
xlim([0,2.5])
ylim([0,2.5])

