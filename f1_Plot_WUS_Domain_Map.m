% Scripts of Figure 1. Plot WUS domain map
% Written by Yiwen Fang, 2021 
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultAxesLineWidth',3,...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',12,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',10)
%% 1) load dataset (can be downloaded on Github)
% STRM DEM map
DATA=ncread('SRTM_elevation_large_matrix.nc','DATA');
DATA(DATA<0)=nan;
lon_map_array_480=ncread('SRTM_elevation_large_matrix.nc','lon_map_array_480');
lat_map_array_480=ncread('SRTM_elevation_large_matrix.nc','lat_map_array_480');

% WUS tile coordinates
load('WUS_SUBDOMAIN_COORDS')

% ASO tile coordinates
ASO_tile=load('COORDS_ASO_tile');

% HUC2 lat/lon
load('WUS_HUC2_boundaries','HUC2_string','HUC2')

% SNOTEL coordinates
load('SNOTEL_SWE_WY1985_2021_high_res','SNOTEL','site_select')
%% 2) Generate plot
figure,set(gcf,'position',[42   81   1015 879])
hold on
whitebg([240/255, 248/255, 255/255])
% WUS tiles
COORDS_all=COORDS;
COORDS1=[];
COORDS2=[];
for j=1:9
    COORDS1=[COORDS1; COORDS_all{1, j}.COORDS_high_elev];
    COORDS2=[COORDS2; COORDS_all{1, j}.COORDS_low_elev];
end
COORDS=[COORDS1; COORDS2];
for j= 1: length(COORDS)
    rectangle('Position',[COORDS(j,2),COORDS(j,1),1,1],'Edgecolor','k','Linewidth',0.5)
end

% WUS DEM
imagesc(lon_map_array_480,lat_map_array_480,DATA,'AlphaData', 0.5)

% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end

% coordinates used for prior b plot
COORDS=[35 -112; 37 -120; 38 -120; 38 -107;39 -107;39 -115;43 -115;46 -122;44 -110;47 -124];%];
for j= 1: length(COORDS)
    rectangle('Position',[COORDS(j,2),COORDS(j,1),1,1],'Edgecolor','k','Linewidth',2)
end

% plot SNOTEL sites > 1500m
Isite=find(SNOTEL.Elev*0.3048>1500); % meter
Isite=intersect(Isite,site_select);
scatter(SNOTEL.lon(Isite),SNOTEL.lat(Isite),20,SNOTEL.Elev(Isite).*0.3048,'filled','MarkerFaceColor',[153,51,0]/255)

% plot tiles have ASO measurements
for j= 1: length(COORDS)
      plot(COORDS(j,2)+0.5,COORDS(j,1)+0.5,'p','MarkerFaceColor',[240/255, 248/255, 255/255],'MarkerEdgeColor',[ 0, 51, 102]/255,'MarkerSize',14,'linewidth',1.5)
end
%% Format figure and add legends
set(gca,'position',[0.1300, 0.2395, 0.7750, 0.6965])
cmap=colormap(flipud(gray));
cmap(1,:)=[240/255, 248/255, 255/255];
colormap(cmap)
c=colorbar;
set(c,'location','southoutside','position',[0.25    0.1133    0.15    0.0283])
axis image
set(gca,'YDir','normal')
xlabel('Longitude')
ylabel('Latitude')
c.Ticks=[0,2000,4000];
c.TickLabels={'0','2000','4000 m'};
xlim([-125,-102])
ylim([31,49])
set(gca,'Box','on', 'Layer', 'top','linewidth',3,'TickDir','out') 
grid off
set(gca,'XMinorTick','off','YMinorTick','off')
set(gca,'Fontsize',22,'linewidth',1.5,'Fontweight','normal');

LH = plot(nan, nan, 's','LineWidth',2,'MarkerEdgeColor','k','MarkerSize',20);
L{1} = 'tiles used in prior precipitation analysis';
LH2(1) = plot(nan, nan, '.','LineWidth',1,'MarkerEdgeColor',[153,51,0]/255,'MarkerSize',20);
L2{1} = 'SNOTEL sites   ';
LH2(2) = plot(nan, nan,'p','MarkerFaceColor',[240/255, 248/255, 255/255],'MarkerEdgeColor',[ 0, 51, 102]/255,'MarkerSize',14,'linewidth',1.5);
L2{2} = 'ASO tiles';

set(gca,'fontsize',26,'linewidth',4)
HUC2text={'CA';'PN';'GB';'UCRB';'MO';'LCRB';'TG';'RG';'AWR'};
location=[-119,35.5;-119,46;-117 39.5;-110.5 38.6;-106 45;-113 33.5;-103.3 33.5;-106.5 33; -104.5 37];
text(location(:,1),location(:,2),HUC2text,'Fontsize',26,'color',[77 0 0]/255)
text(-104,48,'SRR','Fontsize',26,'color',[77 0 0]/255)
plot([-103,-102.2],[48.3,48.8],'color',[77 0 0]/255)
legend('boxoff')
lg=legend(LH, L,'Orientation','horizontal','Fontsize',22);
set(lg,'position',[0.49    0.07    0.315    0.0442])

ah1=axes('position',get(gca,'position'),'Visible','off');
lg2=legend(ah1,LH2 , L2,'Orientation','horizontal','Fontsize',22,'Fontweight','normal');
set(lg2,'position',[0.52    0.105    0.24    0.0442])
legend(ah1,'boxoff')
%% A few setting before printing
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]); 
set(gcf, 'Renderer', 'painters')
%print('-painters','f1_domain_map','-dpng')