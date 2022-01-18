%% Timeseries of SWE volumes (WUS-wide + subbasin)
%% 1) load dataset
% WUS tile coordinates
load('WUS_SUBDOMAIN_COORDS')

% HUC2 lat/lon
load('WUS_HUC2_boundaries','HUC2_string','HUC2')

% SNOTEL coordinates
load('SNOTEL_SWE_WY1985_2021_high_res','SNOTEL','site_select')

% path where stores .nc data
output_dir='DEFINE_YOUR_OWN_PATH_HERE';

figure,
%set(gcf,'position',[13 200 1351 785])
set(gcf,'position',[13 200 1578 850])
c=[255  255  255;245  245     245; 211 211 211;
    170  212.5  226.6667
    85  170  198.3333
    0  127  170
    0   85  141.6667
    0   42.5  113.3333
    0         0   85
    77 0 38
    77 0 0]/255;

load('/Users/yiwenff/Desktop/WUS_SNOW_RANALYSIS/Other_SWE_products/Processed_WUS_basin_outputs/Reanalysis/Reanalysis_masked_WUS_WY2019.mat')
ibasin = [1:3,5,9];
iothers=[4,6:8];

% pile up plot
SWE_pileup=SWE_V(ibasin,:);
SWE_pileup(6,:)=nansum(SWE_V(iothers,:));
ax5=subplot(1,2,1);
set(gca,'position',[0.06 0.62 0.21 0.345])
dowy=datenum(2018,10,1):datenum(2019,9,30);
sv=area(dowy,SWE_pileup','Facealpha',0.6);
newcolors=c([11,8,6,4,3,2],:);
whitebg([1 1 1])
%newcolors = [27 79 114; 46 134 193; 93 173 226; 133 193 233;174 214 241;235 245 251]./255;
for j=1:6
    sv(j).FaceColor=newcolors(j,:);
end
hold on
plot(dowy,nansum(SWE_pileup),'linewidth',2.5)
set(gca,'fontsize',22)
xlabel('DOWY','fontsize',25)
datetick('x','mmm')
ylabel('SWE Volumes (km^3)','fontsize',25)
hold on
plot([152 152],ylim,'k--')
lg=legend('CA','PN','GB','UCRB','MO','Others','WUS');
lg.FontSize=18;
box on
set(gca,'linewidth',2.5)
t1=text(dowy(15),40,'(a)','fontsize',25,'FontWeight','bold');

%% Sample plot outputs (WY 2018 March 1st; April 1st)
c=[255  255  255;245  245     245;
    229 228 226;
    211 211 211
    170  212.5  226.6667;
    85  170  198.3333
    0  127  170
    0   85  141.6667
    0 39.74 111
    77 0 38
    ]/255;
SNOW=c(2:end,:); map=colormap(SNOW); 
map=[interp1([1:4]',map(1:4,:),linspace(1,4,4*25)); interp1([1:6]',map(4:end,:),linspace(1,6,6*10*10))]; 
map(1,:)=[1 1 1];
colormap(map)
WY=2019;
year_end = num2str(WY);
append_year = [num2str(WY-1) '_' year_end(3:4)];

%time_flag=1; % 1) April 1st
time_flag=2; % 2) March 1st
if time_flag==1
    if yeardays(WY)==366
        doy_p=92+31+29+31+1;
    else
        doy_p=92+31+28+31+1;
    end
else
    if yeardays(WY)==366
        doy_p=92+31+29+1;
    else
        doy_p=92+31+28+1;
    end
end

subplot(2,2,3);
set(gca,'position',[0.06 0.08 0.21 0.45])
hold on
ctmp=load('WUS_SUBDOMAIN_COORDS.mat');
COORDS=abs([ctmp.COORDS{1, 1}.COORDS_high_elev;ctmp.COORDS{1, 1}.COORDS_low_elev;ctmp.COORDS{1, 3}.COORDS_high_elev]);

for i_tile= 1:size(COORDS,1)
    %%
    hemi='W';
    coords=COORDS(i_tile,:);
    tile_string = ['N' num2str(coords(1,1)) '_0' hemi num2str(coords(1,2)) '_0'];
    disp(['Extracting variables for tile ' tile_string ' in WY ' append_year])
    filename = [output_dir tile_string '_agg_16/WY' num2str(WY) '/SWE_SCA_POST/' tile_string '_agg_16_SWE_SCA_POST_WY' append_year '.nc'];
    lat=ncread(filename,'Latitude',[1],[Inf]);
    lon=ncread(filename,'Longitude',[1],[Inf]);
    %[PIXEL_AREA,~,~,~,~]=compute_grid_cell_areas_from_latlon_grid(lat,lon);
    % Extract Peak SWE and date
    data=squeeze(ncread(filename,'SWE_Post',[1 1 3 1],[Inf Inf 1 Inf])); %km^3
    %data=squeeze(ncread(filename,'SWE_Post',[1 1 3 1],[Inf Inf 1 Inf])).*PIXEL_AREA.*10^-9; %km^3
    I=find(data<0); if ~isempty(I); data(I)=NaN; end
    
    imagesc(lon,lat,data(:,:,doy_p))
end
xlabel('Longitude')
ylabel('Latitude')
% end
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
colormap(map)
axis image
set(gca,'YDir','normal')
xlim([-120.4546 -118.4635])
ylim([36.7378   39.1081])
caxis([0,2])
box on
xlabel('');ylabel('');
set(gca,'TickDir','in');
grid off
set(gca,'XMinorTick','off','YMinorTick','off')
set(gca,'Fontsize',22,'linewidth',2.5,'Fontweight','bold', 'Layer', 'top');
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]); 
t2=text(-120.32,37,'(b)','fontsize',25,'FontWeight','bold');

%% WUS wide
load /Users/yiwenff/Desktop/SWE_reanalysis_preprocessing/github_testing/SWE_reanalysis_pre_and_post_processing-master/COORDS_WUS.mat
COORDS=abs([COORDS_high_elev;COORDS_low_elev]);

subplot(1,2,2)
set(gca,'position', [0.3 0.08 0.65 0.8850])
set(subplot(1,2,2),'color',[240/255, 248/255, 255/255])
hold on
for i_tile= 1:size(COORDS,1)
    %%
    hemi='W';
    coords=COORDS(i_tile,:);
    tile_string = ['N' num2str(coords(1,1)) '_0' hemi num2str(coords(1,2)) '_0'];
    disp(['Extrating variables for tile ' tile_string ' in WY ' append_year])
    filename = [output_dir tile_string '_agg_16/WY' num2str(WY) '/SWE_SCA_POST/' tile_string '_agg_16_SWE_SCA_POST_WY' append_year '.nc'];
    lat=ncread(filename,'Latitude',[1],[Inf]);
    lon=ncread(filename,'Longitude',[1],[Inf]);
    %[PIXEL_AREA,~,~,~,~]=compute_grid_cell_areas_from_latlon_grid(lat,lon);
    % Extract Peak SWE and date
    data=squeeze(ncread(filename,'SWE_Post',[1 1 3 1],[Inf Inf 1 Inf])); %km^3
    %data=squeeze(ncread(filename,'SWE_Post',[1 1 3 1],[Inf Inf 1 Inf])).*PIXEL_AREA.*10^-9; %km^3
    I=find(data<0); if ~isempty(I); data(I)=NaN; end
    
    imagesc(lon,lat,data(:,:,doy_p))
end
%% WUS tiles
% HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
xlabel('Longitude')
ylabel('Latitude')
colormap(map)
c=colorbar;
axis image
set(gca,'YDir','normal')
ylabel(c,'Reanalysis SWE (m)','fontsize',27)
xlim([-124.6,-101.8])
ylim([30.9,49.1])
caxis([0,2])
box on
set(gca,'position', [0.33 0.110 0.65 0.7550])
xlabel('');ylabel('');
set(gca,'TickDir','in');
grid off
set(gca,'XMinorTick','off','YMinorTick','off')
set(gca,'Fontsize',25,'linewidth',2.5,'Fontweight','bold', 'Layer', 'top');
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]); 
t3=text(-123.5,32,'(c)','fontsize',25,'FontWeight','bold');
plot([-120.4546 -118.4635,-118.4635,-120.4546,-120.4546],...
    [36.7378,36.7378,39.1081,39.1081,36.7378],'linewidth',2,'color',[77 0 0]/255)
%set(gcf, 'Renderer', 'painters')
%print('-painters','f4_Sample_figures_update_lres','-dpng')
