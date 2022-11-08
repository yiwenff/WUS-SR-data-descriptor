%% Timeseries of SWE volumes (WUS-wide + subbasin)
% Scripts of Figure 4. Sample plot Reanalysis SWE
% Written by Yiwen Fang, 2021 
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultAxesLineWidth',3,...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',12,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',10)
%% 1) load dataset
% Warning: In addition to the data published on Github, you'll need to
% download Netcdf of Reanalysis SWE data in WY 2019 and store them in your
% own output directory; change the output_dir to your own directory
% The directory structure is organized as (e.g., for tile N39_0W120_0):
% output_dir/N39_0W120_0_agg_16/WY2019/SWE_SCA_POST/N39_0W120_0_agg_16_SWE_SCA_POST_WY2018_19.nc'];
msg=['In addition to the data published on Github, you need to 1) download '... 
    'netcdf of Reanalysis SWE data in WY 2019 and store them in your own '...
    'output directory; 2) change the output_dir below to your own directory.'];
f=warndlg(msg,'warning');
uiwait(f);

% WUS tile coordinates
ctmp=load('WUS_SUBDOMAIN_COORDS');

% HUC2 lat/lon
load('WUS_HUC2_boundaries','HUC2_string','HUC2')

% SNOTEL coordinates
load('SNOTEL_SWE_WY1985_2021_high_res','SNOTEL','site_select')

% path where stores .nc data
output_dir='DEFINE_YOUR_OWN_PATH_HERE';

% load SWE volumes
load('Reanalysis_SWE_Volumes_HUC2')

%% set which year to plot
WY=2019; % Water Year 2019
year_end = num2str(WY);
append_year = [num2str(WY-1) '_' year_end(3:4)];

%% 1) Plot daily SWE volumes
% Set colorbar
c=[255  255  255;245  245     245; 211 211 211;
    170  212.5  226.6667
    85  170  198.3333
    0  127  170
    0   85  141.6667
    0   42.5  113.3333
    0         0   85
    77 0 38
    77 0 0]/255;

% Pile up SWE volumes at HUC2 basins
ibasin = [1:3,5,9];
iothers=[4,6:8];
SWE_pileup=SWE_V(ibasin,:);
SWE_pileup(6,:)=nansum(SWE_V(iothers,:));

% Plot SWE volumes timeseries
figure,
set(gcf,'position',[13 200 1578 850])
ax5=subplot(1,2,1);
set(gca,'position',[0.06 0.62 0.21 0.345])
dowy=datenum(2018,10,1):datenum(2019,9,30);
sv=area(dowy,SWE_pileup','Facealpha',0.6);
newcolors=c([11,8,6,4,3,2],:);
whitebg([1 1 1])
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

%% 2) Plot SWE in the Sierra (WY 2019 March 1st; April 1st)
% Set colorbar
c=[255  255  255;245  245  245;
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
COORDS=abs([ctmp.COORDS{1, 1}.COORDS_high_elev;ctmp.COORDS{1, 1}.COORDS_low_elev;ctmp.COORDS{1, 3}.COORDS_high_elev]);

for i_tile= 1:size(COORDS,1)
    % load and plot SWE on a specific day
    hemi='W';
    coords=COORDS(i_tile,:);
    tile_string = ['N' num2str(coords(1,1)) '_0' hemi num2str(coords(1,2)) '_0'];
    disp(['Extracting variables for tile ' tile_string ' in WY ' append_year])
    % Need to change the filepath if needed
    filename = [output_dir tile_string '_agg_16_SWE_SCA_POST_WY' append_year '.nc'];
    
    % Read lat/lon
    lat=ncread(filename,'Latitude',[1],[Inf]);
    lon=ncread(filename,'Longitude',[1],[Inf]);
    
    % Read Ensemble median SWE and set negative values to NaN
    data=squeeze(ncread(filename,'SWE_Post',[1 1 3 1],[Inf Inf 1 Inf])); %km^3
    I=find(data<0); if ~isempty(I); data(I)=NaN; end
    
    % Plot SWE on a specific day
    imagesc(lon,lat,data(:,:,doy_p))
end
xlabel('Longitude')
ylabel('Latitude')
% Plot HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
colormap(map)
axis image
% Set y direction to normal
set(gca,'YDir','normal')
% Format figures
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

%% 3) Plot WUS wide SWE on March 1st
COORDS_WUS=[];
for j = 1:size(ctmp.COORDS,2)
    COORDS_WUS=abs([COORDS_WUS;ctmp.COORDS{1,j}.COORDS_high_elev;ctmp.COORDS{1,j}.COORDS_low_elev]);
end
subplot(1,2,2)
set(gca,'position', [0.3 0.08 0.65 0.8850])
set(subplot(1,2,2),'color',[240/255, 248/255, 255/255])
hold on
for i_tile= 1:size(COORDS_WUS,1)
    % Read and plot SWE
    hemi='W';
    coords=COORDS_WUS(i_tile,:);
    tile_string = ['N' num2str(coords(1,1)) '_0' hemi num2str(coords(1,2)) '_0'];
    disp(['Extrating variables for tile ' tile_string ' in WY ' append_year])
    filename = [output_dir tile_string '_agg_16_SWE_SCA_POST_WY' append_year '.nc'];
    
    % Read lat/lon
    lat=ncread(filename,'Latitude',[1],[Inf]);
    lon=ncread(filename,'Longitude',[1],[Inf]);
    
    % Read ensemble median SWE and set negative values to NaN
    data=squeeze(ncread(filename,'SWE_Post',[1 1 3 1],[Inf Inf 1 Inf])); %km^3
    I=find(data<0); if ~isempty(I); data(I)=NaN; end
    
    % Plot SWE on March 1st for each tile
    imagesc(lon,lat,data(:,:,doy_p))
end

% Plot HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
xlabel('Longitude')
ylabel('Latitude')
% Format figures
colormap(map)
c=colorbar;
axis image
set(gca,'YDir','normal')
ylabel(c,'Reanalysis SWE (m)','fontsize',27)
xlim([-124.6,-101.8])
ylim([30.9,49.1])
caxis([0,2])
box on
set(gca,'position', [0.30 0.08 0.65 0.8850])
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

%% A few setting before printing
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]);
set(gcf, 'Renderer', 'painters')
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperSize',[pos(3), pos(4)])
%print('-painters','f4_Sample_figures_update_lres','-dpdf','-r0')
