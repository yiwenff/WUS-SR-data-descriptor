% Load SWE data
load('Reanalysis_SWE_WY1985_2021_high_res')
load('SNOTEL_SWE_WY1985_2021_high_res')
load('WUS_subdomain_shp')
basinname_str=char({'CA';'PN';'GB';'Others';'UCRB';'Others';'Others';'Others';'MO'});
basinname=char(fieldnames(shp));

h2=figure(1);clf,
basin = [1:3,5,9];
set(gcf,'Position',[100 619 1300 1000])
ha=tight_subplot(2,3,0.05,0.05,0.05);
% Scatter plot for CA, PN, GB, UCRB, MO
for j=1:5
    ibasin=basin(j);
    axes(ha(j))
    b_name=strtrim(basinname(ibasin,:));
    meanSWE=nanmean(Peak_SWE,2);
    % Select elevation > 1500m
    iana=find(SNOTEL.Elev*0.3048>1500 & basinidx.(b_name)==1);
    iana=intersect(iana,site_select);
    % Extract peak SWE
    Insitu=Peak_SWE(iana,:);
    Reanalysis=Peak_SWE_re_post(iana,:);
    Reanalysis_prior=Peak_SWE_re_prior(iana,:);
    % Exclude shallow Peak SWE < 1cm
    I=find(Insitu >0.01 & Reanalysis> 0.01  & isnan(Insitu)~=1 & isnan(Reanalysis)~=1 & isnan(Reanalysis_prior)~=1);
    % density scatter plot
    dscatter(Insitu(I),Reanalysis(I))
    colormap(jet)
    hold on
    plot([0,2.5],[0,2.5],'k','linewidth',1)
    % Compute statistics
    R = corr(Insitu(I),Reanalysis(I));
    MD = mean(Reanalysis(I) - Insitu(I));
    RMSD = sqrt(mean((Insitu(I) - Reanalysis(I)).^2));
%     
%     R2 = corr(Insitu(I),Reanalysis_prior(I))
%     MD2 = mean(Reanalysis_prior(I) - Insitu(I))
%     RMSD2 = sqrt(mean((Insitu(I) - Reanalysis_prior(I)).^2))
    
    text(0.2,2.3,['{\it R} = ' num2str(R, '%.2f')],'FontSize',24)
    text(0.2, 2.05,['{\it MD} = ' num2str(MD, '%.2f') ' m'],'FontSize',24)
    text(0.2, 1.8,['{\it RMSD} = ' num2str(RMSD, '%.2f') ' m'],'FontSize',24)
    grid off
    xlabel('SNOTEL SWE (m)')
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

% Scatter plot for the rest of data
for ibasin = [4,6,8]
    b_name=strtrim(basinname(ibasin,:));
    othermask(ibasin,:,:)=basinidx.(b_name);
end
Isite=max(othermask)';
iana=find(SNOTEL.Elev*0.3048>1500 & Isite==1);
iana=intersect(iana,site_select);
% Extract peak SWE
Insitu=Peak_SWE(iana,:);
Reanalysis=Peak_SWE_re_post(iana,:);
Reanalysis_prior=Peak_SWE_re_prior(iana,:);
% Exclude shallow Peak SWE < 1cm
I=find(Insitu >0.01 & Reanalysis> 0.01 & isnan(Insitu)~=1 & isnan(Reanalysis)~=1 & isnan(Reanalysis_prior)~=1);
axes(ha(6))
% density scatter plot
dscatter(Insitu(I),Reanalysis(I))
colormap(jet)
hold on
plot([0,2.5],[0,2.5],'k','linewidth',1)
R = corr(Insitu(I),Reanalysis(I));
MD = mean(Insitu(I) - Reanalysis(I));
RMSD = sqrt(mean((Insitu(I) - Reanalysis(I)).^2));

% R2 = corr(Insitu(I),Reanalysis_prior(I))
% MD2 = mean(Insitu(I) - Reanalysis_prior(I))
% RMSD2 = sqrt(mean((Insitu(I) - Reanalysis_prior(I)).^2))

text(0.2,2.3,['{\it R} = ' num2str(R, '%.2f')],'FontSize',24)
text(0.2, 2.05,['{\it MD} = ' num2str(MD, '%.2f') ' m'],'FontSize',24)
text(0.2, 1.8,['{\it RMSD} = ' num2str(RMSD, '%.2f') ' m'],'FontSize',24)
grid off
axis equal
xlim([0,2.5])
ylim([0,2.5])
xlabel('SNOTEL SWE (m)')
ylabel('Reanalysis SWE (m)')
set(gca,'FontSize',20)
box off
title('Other basins','FontSize',28)

set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]);
set(gcf, 'Renderer', 'painters')
