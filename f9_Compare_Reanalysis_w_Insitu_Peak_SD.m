% Scripts of Figure 9. Compare Reanalysis with in situ peak SWE
% Written by Yiwen Fang, 2021 
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultAxesLineWidth',3,...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',12,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',10)

%% Load data (can be downloaded on Github)
load('SNOTEL_SD_peak_reanalysis')
load('SNOTEL_SD_WY1985_2021_high_res')
load('CDEC_SD_WY1985_2021');
load('CDEC_SD_peak_reanalysis');

load('WUS_subdomain_shp')
%% Scatter plot for CA, PN, GB, UCRB, MO
basinname_str=char({'CA';'PN';'GB';'Others';'UCRB';'Others';'Others';'Others';'MO'});
basinname=char(fieldnames(shp));

h2=figure(1);clf,
basin = [1:3,5,9];
set(gcf,'Position',[100 619 1300 1000])
ha=tight_subplot(2,3,0.05,0.05,0.05);
% Pekka Kumpulainen (2020). tight_subplot(Nh, Nw, gap, marg_h, marg_w) 
% (https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w), 
% MATLAB Central File Exchange. Retrieved November 11, 2020.

for j=1:5
    ibasin=basin(j);
    axes(ha(j))
    b_name=strtrim(basinname(ibasin,:));
    % Compute mean of peak SWE
    meanSWE=nanmean(Peak_SD,2);
    
    % Select all sites
    iana=find(basinidx.(b_name)==1);
    iana=intersect(iana,site_select);
    
     if j==1 
        % Extract peak SWE
        Insitu=[Peak_SD_CDEC; Peak_SD(iana,:)];
        Reanalysis=[Peak_SD_re_post_CDEC; Peak_SD_re_post(iana,:)];
    else
       % Extract peak SWE
        Insitu=Peak_SD(iana,:);
        Reanalysis=Peak_SD_re_post(iana,:);
    end
    % Extract peak SD
    
    % Exclude shallow Peak SD < 5cm
    I=find(Insitu >0.05 & Reanalysis> 0.05  & isnan(Insitu)~=1 & isnan(Reanalysis)~=1 );
    
    % Count number of sites available
    disp(['# of sites: ' num2str(sum(nansum(Insitu,2)~=0))])
    
    % Count number of site-years available
    disp(['# of site-years: ' num2str(length(I))])
    % Density scatter plot
    dscatter(Insitu(I),Reanalysis(I))
    % Robert Henson (2021). Flow Cytometry Data Reader and Visualization
    %(https://www.mathworks.com/matlabcentral/fileexchange/8430-flow-cytometry-data-reader-and-visualization), 
    % MATLAB Central File Exchange. Retrieved July, 30, 2021.
    colormap(jet)
    hold on
    plot([0,6],[0,6],'k','linewidth',1)
    
    % Compute statistics
    R = corr(Insitu(I),Reanalysis(I));
    MD = mean(Reanalysis(I) - Insitu(I));
    RMSD = sqrt(mean((Insitu(I) - Reanalysis(I)).^2));
    
    % print statistics on figure
    text(0.2,5.5,['{\it R} = ' num2str(R, '%.2f')],'FontSize',24)
    text(0.2, 5.,['{\it MD} = ' num2str(MD, '%.2f') ' m'],'FontSize',24)
    text(0.2, 4.5,['{\it RMSD} = ' num2str(RMSD, '%.2f') ' m'],'FontSize',24)
    grid off
    xlabel('SNOTEL Snow Depth (m)')
    ylabel('Reanalysis Snow Depth (m)')
    set(gca,'FontSize',20)
    title(basinname_str(ibasin,:),'FontSize',28)
    axis equal
    box off
    xlim([0,6])
    ylim([0,6])
    if ismember(ibasin, [1,2,3])
        xlabel('')
    end
end

% Scatter plot for the rest of data (Others)
for ibasin = [4,6,8]
    b_name=strtrim(basinname(ibasin,:));
    othermask(ibasin,:,:)=basinidx.(b_name);
end
Isite=max(othermask)';
iana=find(Isite==1);
iana=intersect(iana,site_select);

% Extract peak SD
Insitu=Peak_SD(iana,:);
Reanalysis=Peak_SD_re_post(iana,:);
Reanalysis_prior=Peak_SD_re_prior(iana,:);

% Exclude shallow Peak SD < 5cm
I=find(Insitu >0.05 & Reanalysis> 0.05 & isnan(Insitu)~=1 & isnan(Reanalysis)~=1 & isnan(Reanalysis_prior)~=1);

axes(ha(6))
% Density scatter plot
dscatter(Insitu(I),Reanalysis(I))
colormap(jet)
hold on
plot([0,6],[0,6],'k','linewidth',1)

% Compute statistics
R = corr(Insitu(I),Reanalysis(I));
MD = mean(Insitu(I) - Reanalysis(I));
RMSD = sqrt(mean((Insitu(I) - Reanalysis(I)).^2));

% Print statistics on figure
text(0.2, 5.5,['{\it R} = ' num2str(R, '%.2f')],'FontSize',24)
text(0.2, 5.0,['{\it MD} = ' num2str(MD, '%.2f') ' m'],'FontSize',24)
text(0.2, 4.5,['{\it RMSD} = ' num2str(RMSD, '%.2f') ' m'],'FontSize',24)
grid off
axis equal
xlim([0,6])
ylim([0,6])
xlabel('SNOTEL Snow Depth (m)')
ylabel('Reanalysis Snow Depth (m)')
set(gca,'FontSize',20)
whitebg(([245/255,245/255,245/255]))
box off
title('Other basins','FontSize',28)

%% A few setting before printing
set(gcf, 'Color', [1 1 1]);
set(gcf, 'Renderer', 'painters')
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperSize',[pos(3), pos(4)])
print('-painters','f9_density_plot_snow_depth_approach1','-dpdf','-r0')
