% Scripts of Figure 6. Compare reanalysis daily SWE and in situ daily SWE 
% Written by Yiwen Fang, 2021 
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultAxesLineWidth',3,...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',12,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',10)
%% Compare daily snotel data with data reanalysis
% getPyPlot_cMap:
% Konrad (2020). PyColormap4Matlab (https://github.com/f-k-s/PyColormap4Matlab), GitHub. Retrieved July 09, 2020.
% tight_subplot:
% Pekka Kumpulainen (2020). tight_subplot(Nh, Nw, gap, marg_h, marg_w) 
% (https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w), 
% MATLAB Central File Exchange. Retrieved November 11, 2020.
RdBl=getPyPlot_cMap('RdBu_r');
Ocn_r=getPyPlot_cMap('ocean_r');
jet_py=getPyPlot_cMap('jet');
trn=getPyPlot_cMap('terrain');

%% load data
load('WUS_HUC2_boundaries','HUC2_string','HUC2')
load('SNOTEL_SWE_WY1985_2021_high_res')
load('Posterior_Reanalysis_SWE_WY1985_2021_daily_high_res')
%% 1) Compute Spatial distribution of correlation, bias, rmse at each site 
nsite=size(Peak_DAY,1);
corre_site=nan(nsite,1);
MD_site=nan(nsite,1);
RMSD_site=nan(nsite,1);
% Compute statistics
for j =1:nsite
snotel=squeeze(SWE(j,:,:));
reanalysis=squeeze(SWE_Reanalysis(j,:,:));
snotel=snotel';
reanalysis=reanalysis';

% find daily SWE > 1 mm
I=find(isnan(snotel)==0 & isnan(reanalysis)==0 & snotel >0.001 & reanalysis >0.001);

if isempty(I)==0
    meanSWE=nanmean(snotel(I));
    corre_site(j)=corr(snotel(I),reanalysis(I));
    MD_site_sz(j)=nanmean(reanalysis(I)-snotel(I))/meanSWE;
    RMSD_site_sz(j)=sqrt(nanmean((snotel(I)-reanalysis(I)).^2))/meanSWE;
    MD_site(j)=nanmean(reanalysis(I)-snotel(I));
    RMSD_site(j)=sqrt(mean((snotel(I)-reanalysis(I)).^2));

end
end
%% 2) Plot Spatial distribution of correlation, bias, rmse 
%figure,whitebg([245/255,245/255,245/255])
ha=tight_subplot(2,2,0.05,0.05,0.05);
set(gcf,'Position',[100 81 1055 725])

% Plot statics for site located higher than 1500 m
Isite=find(isnan(MD_site)==0 & SNOTEL.Elev*0.3048>1500);
Isite=intersect(Isite,site_select);

% (a) Correlation Coefficient R
axes(ha(1))
hold on
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
scatter(SNOTEL.lon(Isite),SNOTEL.lat(Isite),40,corre_site(Isite),'filled','MarkerEdgeColor',[128/255 128/255 128/255])
box on
c=colorbar;
c.Label.String='(-)';
axis equal
%xlabel('Longitude')
ylabel('Latitude')
xlim([-125,-102])
ylim([31,49])
colormap(ha(1),jet_py)
caxis([0.3,1])
text(-104.5,47.5,'(a)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)

% (b) Mean Difference 
axes(ha(2))
hold on
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
scatter(SNOTEL.lon(Isite),SNOTEL.lat(Isite),40,MD_site(Isite),'filled','MarkerEdgeColor',[128/255 128/255 128/255])
c=colorbar;
c.Label.String='(m)';
axis equal
%xlabel('Longitude')
box on
xlim([-125,-102])
ylim([31,49])
colormap(ha(2),RdBl)
caxis([-0.5,0.5])
text(-104.5,47.5,'(b)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)

% (c) Root Mean Squared Difference
axes(ha(3))
hold on
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
box on
scatter(SNOTEL.lon(Isite),SNOTEL.lat(Isite),40,RMSD_site(Isite),'filled','MarkerEdgeColor',[128/255 128/255 128/255])
c=colorbar;
c.Label.String='(m)';
axis equal
xlabel('Longitude')
ylabel('Latitude')
xlim([-125,-102])
ylim([31,49])
%colormap(Bl)
cmap=flipud(autumn);
cmap(1,:)=[1 1 1];
colormap(ha(3),Ocn_r)
caxis([0,0.8])
text(-104.5,47.5,'(c)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)

% (d) Elevation
axes(ha(4))
hold on
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
box on
scatter(SNOTEL.lon(Isite),SNOTEL.lat(Isite),40,SNOTEL.Elev(Isite).*0.3048,'filled','MarkerEdgeColor',[0 0 0])
c=colorbar;
c.Label.String='(m)';
axis equal
xlabel('Longitude')
xlim([-125,-102])
ylim([31,49])
colormap(ha(4),trn)
caxis([0,4000])
text(-104.5,47.5,'(d)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)
%% A few setting before printing
% set(gcf, 'InvertHardCopy', 'off');
% set(gcf, 'Color', [1 1 1]); 
% set(gcf, 'Renderer', 'painters')
% print('-painters','f4_spatial_distribution_of_stats','-dpng')
