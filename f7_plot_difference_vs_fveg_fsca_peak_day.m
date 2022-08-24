% Scripts of Figure 7. peak SWE differences vs. forest fraction/ # of  
% Landsat fSCA images and compare peak SWE days
% Written by Yiwen Fang, 2022 
load('fig7_analysis_data')
%% a) plot RMSD of peak SWE vs. fveg
figure,
whitebg(([245/255,245/255,245/255]))
set(gcf,'position',[47   381   1250   450])
ax1=axes('position',[0.05,0.12,0.23,0.85]);
% Density scatter plot
J=isnan(RMSD);

dscatter(VC(~J),RMSD(~J),'msize',25)
% Robert Henson (2021). Flow Cytometry Data Reader and Visualization
%(https://www.mathworks.com/matlabcentral/fileexchange/8430-flow-cytometry-data-reader-and-visualization),
% MATLAB Central File Exchange. Retrieved July, 30, 2021.
% cmap=colormap(flipud(gray));
% colormap(cmap(10:end,:))
ylim([0,1])
% Can add interquartile range of error bar for VC at different bins

% define bins
nodes=0:10:75;
nbins=length(nodes)-1;
node_mid=(nodes(1:end-1)+nodes(2:end))/2;

bin_VC=nan(nbins,1);
bin_RMSD_mid=nan(nbins,1);
bin_RMSD_25th=nan(nbins,1);
bin_RMSD_75th=nan(nbins,1);

% compute median, 25th, 75th percentile of RMSD for each bin
for ibin=1:nbins
    bin_VC_l=nodes(ibin);
    bin_VC_u=nodes(ibin+1);
    iveg=find(VC>bin_VC_l & VC<=bin_VC_u & ~isnan(RMSD));
    bin_RMSD_mid(ibin)=nanmedian(RMSD(iveg));
    bin_RMSD_25th(ibin)=prctile(RMSD(iveg),25);
    bin_RMSD_75th(ibin)=prctile(RMSD(iveg),75);
end

yneg=bin_RMSD_mid-bin_RMSD_25th;
ypos=bin_RMSD_75th-bin_RMSD_mid;
hold on
errorbar(node_mid,bin_RMSD_mid,yneg,ypos,'red','linewidth',3)
xlabel('Ave. forest fraction','fontsize',20)
ylabel('RMSD of peak SWE (m)','fontsize',20)
box on
set(gca,'fontsize',20)
text(5,0.95,'(a)','Fontsize',18,'FontWeight','bold')

%% subplot b Absolute difference of peak SWE vs. # fSCA measurements
ax2=axes('position',[0.35,0.12,0.23,0.85]);

%diff=RMSD_site;
J=find(~isnan(AB) & ~isnan(fSCA_num));
% Density scatter plot
dscatter(fSCA_num(J),AB(J),'msize',24)
% Robert Henson (2021). Flow Cytometry Data Reader and Visualization
%(https://www.mathworks.com/matlabcentral/fileexchange/8430-flow-cytometry-data-reader-and-visualization),
% MATLAB Central File Exchange. Retrieved July, 30, 2021.
% cmap=colormap(flipud(gray));
% colormap(cmap(10:end,:))
ylim([0,1])
% Can add interquartile range of error bar for VC at different bins

% define bins
nodes=0:10:75;
nbins=length(nodes)-1;
node_mid=(nodes(1:end-1)+nodes(2:end))/2;

bin_fSCA=nan(nbins,1);
bin_RMSD_mid=nan(nbins,1);
bin_RMSD_25th=nan(nbins,1);
bin_RMSD_75th=nan(nbins,1);

% compute median, 25th, 75th percentile of absolute difference for each bin
for ibin=1:nbins
    bin_fSCA_l=nodes(ibin);
    bin_fSCA_u=nodes(ibin+1);
    ifSCA=find(fSCA_num>bin_fSCA_l & fSCA_num<=bin_fSCA_u & ~isnan(AB));
    bin_RMSD_mid(ibin)=nanmedian(AB(ifSCA));
    bin_RMSD_25th(ibin)=prctile(AB(ifSCA),25);
    bin_RMSD_75th(ibin)=prctile(AB(ifSCA),75);
end

yneg=bin_RMSD_mid-bin_RMSD_25th;
ypos=bin_RMSD_75th-bin_RMSD_mid;
hold on
errorbar(node_mid,bin_RMSD_mid,yneg,ypos,'red','linewidth',2)
xlabel('Number of fSCA meas.','fontsize',20)
ylabel('RMSD of Daily SWE','fontsize',20)
ylabel('Absolute difference of peak SWE (m)','fontsize',20)

box on
set(gca,'fontsize',20,'Layer','Top')
text(70,0.95,'(b)','Fontsize',18,'FontWeight','bold')

%% subplot c Peak SWE day comparison
% Screen out shallow SWE day
I=find(PeakSWE_Reanalysis >0.01 & PeakSWE_insitu > 0.01  &...
    isnan(PeakSWE_insitu)~=1 & isnan(PeakSWE_Reanalysis)~=1);

% Compute differences of peak SWE days
diff=Peak_SWE_DAY_Reanalysis(I)-Peak_SWE_DAY_insitu(I);

% density plot of WUS-SR peak SWE day vs. in situ peak SWE day
ax3=axes('position',[0.65,0.12,0.35,0.85]);
dscatter(Peak_SWE_DAY_insitu(I),Peak_SWE_DAY_Reanalysis(I),'msize',22)
hold on
plot([0,300],[0,300],'r')
axis equal
xlim([50,300])
ylim([50,300])
cmap=colormap(flipud(gray));
colormap(cmap(4:end,:))
xlabel('In situ Peak SWE day','fontsize',20)
ylabel('Reanalysis Peak SWE day','fontsize',20)
set(gca,'fontsize',20)
text(62,287.5,'(c)','Fontsize',18,'FontWeight','bold')

% compute R, MD, RMSD for peak SWE differences
R=corr(Peak_SWE_DAY_insitu(I),Peak_SWE_DAY_Reanalysis(I));
MD = mean(Peak_SWE_DAY_Reanalysis(I) - Peak_SWE_DAY_insitu(I));
RMSD = sqrt(mean((Peak_SWE_DAY_insitu(I) - Peak_SWE_DAY_Reanalysis(I)).^2));

box on
%% A few setting before printing
set(gcf, 'Color', [1 1 1]);
set(gcf, 'Renderer', 'painters')
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperSize',[pos(3), pos(4)])
print('-painters','f7_peak_SWE_analysis','-dpdf','-r0')