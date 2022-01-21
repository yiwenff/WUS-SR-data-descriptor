% Scripts of Figure 3. Landsat fSCA measurements
% Written by Yiwen Fang, 2021 

set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultAxesLineWidth',3,...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',12,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',10)

%% Load dataset (can be downloaded on Github)
% Load HUC2 lat/lon
load('WUS_HUC2_boundaries','HUC2_string','HUC2')
% load landsat measurements data
load('Landsat_meas_data')

%% 1) Plot timeline of landsat missions
figure,set(gcf,'position',[44   350   927   927])
ax5=subplot(3,2,5);
set(ax5,'position',[0.0700    0.085    0.87    0.13])

% getPyPlot_cMap Konrad (2020). PyColormap4Matlab (https://github.com/f-k-s/PyColormap4Matlab), GitHub. Retrieved July 09, 2020.
cmrmap=getPyPlot_cMap('CMRmap_r',11); % getPyPlot_cMap 

% plot periods when only one landsat is available
rectangle('Position',[1985 5 14.7 20],'Facecolor',[232 232 232]/255,'Edgecolor','none')
hold on
rectangle('Position',[2012.17 5 1.33 20],'Facecolor',[232 232 232]/255,'Edgecolor','none')

% plot Landsat 5,7,8 timelines
rectangle('Position',[1985 18.7 27.17 2.6],'Facecolor',cmrmap(10,:),'Edgecolor','none')
rectangle('Position',[1999.7 13.7 21.3 2.6],'Facecolor',cmrmap(10,:),'Edgecolor','none') % 1999.06 = WY1999.7
rectangle('Position',[2013.5 8.7 7.5 2.6],'Facecolor',cmrmap(10,:),'Edgecolor','none') % 2013.04= WY 2013.5
% draw tridiagle
patch('Faces',[1,2,3],'Vertices',[2021,13.7; 2022,15;2021,16.3],'Facecolor',cmrmap(10,:),'Edgecolor','none')
patch('Faces',[1,2,3],'Vertices',[2021,8.7; 2022,10;2021,11.3],'Facecolor',cmrmap(10,:),'Edgecolor','none')

% plot WY 1992, 2002, 2012, 2018 periods 
r1=rectangle('Position',[1992,5,1,20],'Facecolor','none','Edgecolor',[cmrmap(5,:)],'LineStyle','-','linewidth',1.5);
r2=rectangle('Position',[2002,5,1,20],'Facecolor','none','Edgecolor',[cmrmap(5,:)],'LineStyle','-','linewidth',1.5);
r3=rectangle('Position',[2012,5,1,20],'Facecolor','none','Edgecolor',[cmrmap(5,:)],'LineStyle','-','linewidth',1.5);
r4=rectangle('Position',[2018,5,1,20],'Facecolor','none','Edgecolor',[cmrmap(5,:)],'LineStyle','-','linewidth',1.5);
plot([1992*ones(10,1),1993*ones(10,1)]',[6:2:25;5:2:24],'color',cmrmap(5,:),'linewidth',1.5)
plot([2002*ones(10,1),2003*ones(10,1)]',[6:2:25;5:2:24],'color',cmrmap(5,:),'linewidth',1.5)
plot([2012*ones(10,1),2013*ones(10,1)]',[6:2:25;5:2:24],'color',cmrmap(5,:),'linewidth',1.5)
plot([2018*ones(10,1),2019*ones(10,1)]',[6:2:25;5:2:24],'color',cmrmap(5,:),'linewidth',1.5)

% Format figure, add labels and titles 
xlim([1983,2023])
ylim([5,25])
grid off
box on
set(gca,'xgrid','on');
yticklabels({'', '8','7','5',''})
set(gca,'YMinorTick','off', 'Layer', 'top')
xlabel('Water Year')
ylabel('Landsat')
set(gca,'Fontsize',22)
text(1983.8,9,'(e)','Fontsize',18,'FontWeight','bold')
ax(1)=subplot(3,2,1);
set(ax(1),'position',[0.070    0.66    0.35    0.3])
ax(2)=subplot(3,2,2);
set(ax(2),'position',[0.5600    0.66    0.35    0.3])
ax(3)=subplot(3,2,3);
set(ax(3),'position',[0.070    0.29    0.35    0.3])
ax(4)=subplot(3,2,4);
set(ax(4),'position',[0.5600    0.29    0.35    0.3])

agg='16';
lbl=['(a)';'(b)';'(c)';'(d)'];
%% 2) plot landsat measurements at WY 1992, 2002, 2012, and 2018
whitebg([240/255, 248/255, 255/255])
WYs=[1992, 2002, 2012, 2018];
for iyear=1:length(WYs)
    axes(ax(iyear))
    hold on
    disp(['Process WY' num2str(WYs(iyear))])
    WY_text=num2str(WYs(iyear));
    WY1_string=num2str(str2num(WY_text)-1);
    WY2_string=WY_text(end-1:end);
    WY_string=[WY1_string '_' WY2_string];
    % plot number of measurements for each year
    imagesc(lon_map_array_480,lat_map_array_480,MEAS_NUM(:,:,iyear))  
    grid on
    
    % add HUC2 domain
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[28,40,51]/255,'Linewidth',1.5)
end
    % Format figure, add labels and titles 
    c=colorbar;
    caxis([0 80])
    colormap(cmrmap)
    ylabel(c,'(#)')
    axis image
    set(gca,'YDir','normal')
    
    xlim([-125,-102])
    ylim([31,49])
    xlabel('Longitude')
    ylabel('Latitude')
    if iyear==1
        title(['WY ' WY_text ' (Landat 5 only)'])
    elseif iyear==2
        title(['WY ' WY_text ' (Landsat 5 and 7)'])
    elseif iyear==3
        title(['WY ' WY_text ' (Landsat 5 mostly)'])
    elseif iyear==4
        title(['WY ' WY_text ' (Landsat 7 and 8)'])
    end
    set(gca,'Fontsize',22, 'Layer', 'top')
    box on
    
    text(-123.8,32.5,lbl(iyear,:),'Fontsize',18,'FontWeight','bold')
    
    if iyear==1
        xlabel('')
    elseif iyear==2
        xlabel('')
        ylabel('')
    elseif iyear==4
        ylabel('')
    end
end

% Set axes positions
set(ax5,'position',[0.0700    0.085    0.87    0.13])
set(ax(1),'position',[0.070    0.66    0.35    0.3])
set(ax(2),'position',[0.5600    0.66    0.35    0.3])
set(ax(3),'position',[0.070    0.29    0.35    0.3])
set(ax(4),'position',[0.5600    0.29    0.35    0.3])
set(ax5,'color',[1 1 1])

%% A few setting before printing
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]);
set(gcf, 'Renderer', 'painters')
%print('-painters','f3_number_of_landsat_image','-dpng')
