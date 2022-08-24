% Scripts of Figure 8. Compare reanalysis daily SWE and in situ daily SWE 
% Written by Yiwen Fang, 2021 
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultAxesLineWidth',3,...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',12,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',10)
%% Compare daily insitu data with data reanalysis
% getPyPlot_cMap:
% Konrad (2020). PyColormap4Matlab (https://github.com/f-k-s/PyColormap4Matlab), GitHub. Retrieved July 09, 2020.
% tight_subplot:
% Pekka Kumpulainen (2020). tight_subplot(Nh, Nw, gap, marg_h, marg_w) 
% (https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w), 
% MATLAB Central File Exchange. Retrieved November 11, 2020.
RdBl=getPyPlot_cMap('RdBu_r');
Ocn_r=getPyPlot_cMap('ocean_r');
PuBu=getPyPlot_cMap('PuBu');

jet_py=getPyPlot_cMap('jet');
trn=getPyPlot_cMap('terrain');

%% load data
load('WUS_HUC2_boundaries','HUC2_string','HUC2')
Insitu_SNOTEL=load('SNOTEL_SWE_WY1985_2021_high_res');
Insitu_CDEC=load('CDEC_SWE_WY1985_2021');
Reanalysis_SNOTEL=load('Posterior_Reanalysis_SWE_WY1985_2021_daily_SNOTEL');
Reanalysis_CDEC=load('Posterior_Reanalysis_SWE_WY1985_2021_daily_CDEC');
%% 1) Compute Spatial distribution of correlation, bias, rmse at each site 
nsite=length(Insitu_SNOTEL.site_select)+size(Insitu_CDEC.Peak_SWE_day_CDEC,1);
corre_site=nan(nsite,1);
MD_site_sz=nan(nsite,1);
RMSD_site_sz=nan(nsite,1);
MD_site=nan(nsite,1);
RMSD_site=nan(nsite,1);

Insitu=[Insitu_CDEC.SWE_CDEC;Insitu_SNOTEL.SWE(Insitu_SNOTEL.site_select,:,:)];
Reanalysis=[Reanalysis_CDEC.SWE_Reanalysis_post;Reanalysis_SNOTEL.SWE_Reanalysis_post(Insitu_SNOTEL.site_select,:,:)];
LON=[Insitu_CDEC.CDEC.lon;Insitu_SNOTEL.SNOTEL.lon(Insitu_SNOTEL.site_select)];
LAT=[Insitu_CDEC.CDEC.lat;Insitu_SNOTEL.SNOTEL.lat(Insitu_SNOTEL.site_select)];
ELEV=[Insitu_CDEC.CDEC.ElevationMeter;Insitu_SNOTEL.SNOTEL.Elev(Insitu_SNOTEL.site_select)*0.3048];

% Compute statistics
for j =1:nsite
    insitu=squeeze(Insitu(j,:,:));
    reanalysis=squeeze(Reanalysis(j,:,:));
    insitu=insitu';
    reanalysis=reanalysis';
    
    % find daily SWE > 1 mm
    I=find(isnan(insitu)==0 & isnan(reanalysis)==0 & insitu >0.00254 & reanalysis >0.00254);
    
    if isempty(I)==0
        maxSWE=max(insitu(I));
        if maxSWE>0.01
            corre_site(j)=corr(insitu(I),reanalysis(I));
            MD_site_sz(j)=nanmean(reanalysis(I)-insitu(I))/maxSWE;
            RMSD_site_sz(j)=sqrt(nanmean((insitu(I)-reanalysis(I)).^2))/maxSWE;
            MD_site(j)=nanmean(reanalysis(I)-insitu(I));
            RMSD_site(j)=sqrt(mean((insitu(I)-reanalysis(I)).^2));
        end
    end
end
disp(['median of R: ' num2str(nanmedian(corre_site))])
disp(['median of MD: ' num2str(nanmedian(MD_site_sz))])
disp(['median of RMSD: ' num2str(nanmedian(RMSD_site_sz))])

%% 2) Plot Spatial distribution of correlation, bias, rmse 
figure,whitebg([245/255,245/255,245/255])
ha2=tight_subplot(3,2,0.05,0.05,0.05);
set(gcf,'Position',[100 81 950 900])

% Plot statics for all sites
Isite=find(isnan(MD_site)==0 );

% (a) Correlation Coefficient R
axes(ha2(1))
hold on
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
scatter(LON(Isite),LAT(Isite),40,corre_site(Isite),'filled','MarkerEdgeColor',[128/255 128/255 128/255])
box on
c=colorbar;
c.Label.String='(-)';
axis equal
%xlabel('Longitude')
ylabel('Latitude')
xlim([-125,-102])
ylim([31,49])
colormap(ha2(1),jet_py)
caxis([0.3,1])
text(-104.5,47.5,'(a)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)
%text(-124,32.5,'R^2','FontSize',22)

% (d) Elevation
axes(ha2(2))
hold on
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
box on
scatter(LON(Isite),LAT(Isite),40,ELEV(Isite),'filled','MarkerEdgeColor',[0 0 0])
c=colorbar;
c.Label.String='(m)';
axis equal
xlim([-125,-102])
ylim([31,49])
colormap(ha2(2),trn)
caxis([0,4000])
text(-104.5,47.5,'(b)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)
%text(-124,32.5,'Elevation','FontSize',22)

% (c) Mean Difference 
axes(ha2(3))
hold on
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
scatter(LON(Isite),LAT(Isite),40,MD_site(Isite),'filled','MarkerEdgeColor',[128/255 128/255 128/255])
c=colorbar;
c.Label.String='(m)';
axis equal
%xlabel('Longitude')
box on
xlim([-125,-102])
ylabel('Latitude')
ylim([31,49])
colormap(ha2(3),RdBl)
caxis([-0.3,0.3])
c.Ticks=-0.3:0.1:0.3;
text(-104.5,47.5,'(c)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)
%text(-124,32.5,'MD','FontSize',22)

% (d) Root Mean Squared Difference
axes(ha2(4))
hold on
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
box on
scatter(LON(Isite),LAT(Isite),40,RMSD_site(Isite),'filled','MarkerEdgeColor',[128/255 128/255 128/255])
c=colorbar;
c.Label.String='(m)';
axis equal
xlim([-125,-102])
ylim([31,49])
%colormap(Bl)
colormap(ha2(4),PuBu)
caxis([0,0.5])
text(-104.5,47.5,'(d)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)
%text(-124,32.5,'RMSD','FontSize',22)

% (e) Mean Difference 
axes(ha2(5))
hold on
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
scatter(LON(Isite),LAT(Isite),40,MD_site_sz(Isite)*100,'filled','MarkerEdgeColor',[128/255 128/255 128/255])
c=colorbar;
c.Label.String='(%)';
axis equal
%xlabel('Longitude')
box on
xlim([-125,-102])
ylim([31,49])
colormap(ha2(5),RdBl)
caxis([-30,30])
ylabel('Latitude')
xlabel('Longitude')
c.Ticks=-30:10:30;
text(-104.5,47.5,'(e)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)
%text(-124,32.5,'$\frac{MD}{Max. SWE}$','FontSize',22)

% (f) Root Mean Squared Difference
axes(ha2(6))
hold on
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
box on
scatter(LON(Isite),LAT(Isite),40,RMSD_site_sz(Isite)*100,'filled','MarkerEdgeColor',[128/255 128/255 128/255])
c=colorbar;
c.Label.String='(%)';
axis equal
xlabel('Longitude')
xlim([-125,-102])
ylim([31,49])
%colormap(Bl)
cmap=flipud(autumn);
cmap(1,:)=[1 1 1];
colormap(ha2(6),PuBu)
caxis([0,30])
text(-104.5,47.5,'(f)','FontSize',22,'FontWeight','bold')
set(gca,'FontSize',22)
%% A few setting before printing
set(gcf, 'Color', [1 1 1]);
set(gcf, 'Renderer', 'painters')
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperSize',[pos(3), pos(4)])
print('-painters','f8_spatial_distribution_daily_swe_difference','-dpdf','-r0')