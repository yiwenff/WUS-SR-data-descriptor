% Scripts of Figure 5. Compare Reanalysis with in situ peak SWE
% Written by Yiwen Fang, 2022 
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultAxesLineWidth',3,...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',12,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',10)

%% Load data (can be downloaded on Github)
load('SNOTEL_SWE_peak_reanalysis_best_match')
load('SNOTEL_SWE_WY1985_2021_high_res')
load('CDEC_SWE_WY1985_2021');
load('CDEC_SWE_peak_reanalysis_best_match')

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
    disp(b_name)
    % Compute mean of peak SWE
    meanSWE=nanmean(Peak_SWE,2);
    
    % Select elevation > 1500m
    iana=find(basinidx.(b_name)==1);
    iana=intersect(iana,site_select);
    
    if j==1
        % Extract peak SWE for data from SNOTEL and CDEC in CA
        Insitu=[Peak_SWE_CDEC; Peak_SWE(iana,:)];
        Reanalysis=[Peak_SWE_re_post_CDEC; Peak_SWE_re_post(iana,:)];
        
    else
        % Extract peak SWE
        Insitu=Peak_SWE(iana,:);
        Reanalysis=Peak_SWE_re_post(iana,:);
    end
    % Count number of sites available
    disp(['# of sites: ' num2str(sum(nansum(Insitu,2)~=0))])
    % Exclude shallow Peak SWE < 1cm
    I=find(Insitu >0.01 & Reanalysis> 0.01  & isnan(Insitu)~=1 & isnan(Reanalysis)~=1 );
    
    % Density scatter plot
    dscatter(Insitu(I),Reanalysis(I))
    % Robert Henson (2021). Flow Cytometry Data Reader and Visualization
    %(https://www.mathworks.com/matlabcentral/fileexchange/8430-flow-cytometry-data-reader-and-visualization), 
    % MATLAB Central File Exchange. Retrieved July, 30, 2021.
    
    % Count number of site-years available
    disp(['# of site-years: ' num2str(length(I))])
    colormap(jet)
    hold on
    plot([0,2.5],[0,2.5],'k','linewidth',1)
    
    % Compute statistics
    R = corr(Insitu(I),Reanalysis(I));
    MD = mean(Reanalysis(I) - Insitu(I));
    RMSD = sqrt(mean((Insitu(I) - Reanalysis(I)).^2));

    
    % print statistics on figure
    text(0.2,2.3,['{\it R} = ' num2str(R, '%.2f')],'FontSize',24)
    text(0.2, 2.05,['{\it MD} = ' num2str(MD, '%.2f') ' m'],'FontSize',24)
    text(0.2, 1.8,['{\it RMSD} = ' num2str(RMSD, '%.2f') ' m'],'FontSize',24)
    grid off
    xlabel('In situ SWE (m)')
    ylabel('Reanalysis SWE (m)')
    set(gca,'FontSize',20)
    title(basinname_str(ibasin,:),'FontSize',28)
    axis equal
    box off
    xlim([0,2.5])
    ylim([0,2.5])
    if ismember(ibasin, [1,2,3])
        xlabel('')
    end
end

% Scatter plot for the rest of data (Others)
disp('Others')
for ibasin = [4,6,8]
    b_name=strtrim(basinname(ibasin,:));
    othermask(ibasin,:,:)=basinidx.(b_name);
end
Isite=max(othermask)';
iana=find(Isite==1);
iana=intersect(iana,site_select);

% Extract peak SWE
Insitu=Peak_SWE(iana,:);
Reanalysis=Peak_SWE_re_post(iana,:);
disp(['# of sites: ' num2str(sum(nansum(Insitu,2)~=0))])

% Exclude shallow Peak SWE < 1cm
I=find(Insitu >0.01 & Reanalysis> 0.01 & isnan(Insitu)~=1 & isnan(Reanalysis)~=1 );
disp(['# of site-years: ' num2str(length(I))])

axes(ha(6))
% Density scatter plot
dscatter(Insitu(I),Reanalysis(I))
colormap(jet)
hold on
plot([0,2.5],[0,2.5],'k','linewidth',1)

% Compute statistics
R = corr(Insitu(I),Reanalysis(I));
MD = mean(Insitu(I) - Reanalysis(I));
RMSD = sqrt(mean((Insitu(I) - Reanalysis(I)).^2));

% Print statistics on figure
text(0.2, 2.3,['{\it R} = ' num2str(R, '%.2f')],'FontSize',24)
text(0.2, 2.05,['{\it MD} = ' num2str(MD, '%.2f') ' m'],'FontSize',24)
text(0.2, 1.8,['{\it RMSD} = ' num2str(RMSD, '%.2f') ' m'],'FontSize',24)
grid off
axis equal
xlim([0,2.5])
ylim([0,2.5])
xlabel('In situ SWE (m)')
ylabel('Reanalysis SWE (m)')
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
%print('-painters','f6_density_plot_SWE_approach2','-dpdf','-r0')
