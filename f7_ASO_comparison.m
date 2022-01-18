set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultLineLineWidth',1.5,'DefaultLineMarkerSize',6,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',16,...
    'DefaultAxesFontWeight','bold','DefaultAxesLinewidth',1.5,...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',16)
clear;clc;
c=[255  255  255;245  245     245;     
229 228 226;
211 211 211
    170  212.5  226.6667;
    85  170  198.3333
    0  127  170
    0   85  141.6667
    0 39.74 111
    ]/255;
SNOW=c(2:end,:); map=colormap(SNOW); 
map=[interp1([1:4]',map(1:4,:),linspace(1,4,4*25)); interp1([1:5]',map(4:end,:),linspace(1,5,5*10*10))]; 
map(1,:)=[1 1 1];
% getPyPlot_cMap Konrad (2020). PyColormap4Matlab (https://github.com/f-k-s/PyColormap4Matlab), GitHub. Retrieved July 09, 2020.
RdBl=getPyPlot_cMap('RdBu_r');
RdBl(64,:)=[1 1 1];
RdBl(65,:)=[1 1 1];
%%
figure
whitebg(([245/255,245/255,245/255]))
ASOday=[1;1;1]; % Tuolumne, OL, CM
ASOnames=['USCATB_WY2017_DOWY183';'USWAOL_WY2016_DOWY181';'USCOCM_WY2019_DOWY189'];
xlims=[-119.79, -119.19;-123.7, -123.1;-107.001,-106.741];
ylims=[37.7,38.2; 47.5,48.0; 38.967,39.184];
ticks_x=[-119.7 -119.5 -119.3;-123.6 -123.4 -123.2;-107 -106.9 -106.8];
ticks_y=[37.8 38 38.2; 47.6 47.8 48; 39 39.1 39.2];
figure;clf;set(gcf,'Position', [10 100 1500 1200])
ha=tight_subplot(3,4,0.05,0.05,0.05);
iplot=0;
for iASO=1:3
    ASO_name=ASOnames(iASO,:);
    iday=ASOday(iASO);
    load(ASO_name)
    clear map_data1 map_data2 map_data3
    
    map_data3=NEW_REANALYSIS_SWE(:,:,iday);
    map_data1=ASO_SWE_interp(:,:,iday);
    
    if iASO==2
        load('Re_mask_WAOL')
        map_data3=NEW_REANALYSIS_SWE(:,:,iday).*Mask_seasonal;
        map_data1=map_data1.*Mask_seasonal;
        %map_data3=NEW_REANALYSIS_SWE(:,:,iday);
        %map_data3(map_data3>3)=nan;
    end
    map_data1=map_data1(Ilat,Ilon);
    iplot=iplot+1;
    axes(ha(iplot))
    imAlpha=ones(size(map_data1));
    imAlpha(isnan(map_data1))=0;
    imagesc(longitude(Ilon),latitude(Ilat),map_data1,'AlphaData',imAlpha)
    set(gca,'YDir','normal')
    h=colorbar;
    %ylabel(h,'SWE (m)','FontSize',20)
    caxis([0 round(10*prctile(map_data1(:),98))/10])
    title(['ASO SWE' ])
    if iASO==1
        title([{'ASO SWE'} {'USCATB'}])
    elseif iASO==2
        title(['USWAOL'])
    else
        title(['USCOCM'])
    end
    %map=colormap;
    %map(1,:)=[1 1 1];
    %map=snowmap;
    colormap(gca,map)
    axis equal
    set(gca,'Fontsize',24)
    xlim(xlims(iASO,:))
    ylim(ylims(iASO,:))
    xticks(ticks_x(iASO,:))
    yticks(ticks_y(iASO,:))
    %saveas(gcf,['ASO_SWE_' num2str(ASO_DOWY(iday)) '_2K.png'] )
    
    
    %figure;set(gcf,'Position', [10 100 1000 750])
    iplot=iplot+1;
    axes(ha(iplot))
    
    map_data3(nan_mask)=NaN;
    map_data3=map_data3(Ilat,Ilon);
    imAlpha=ones(size(map_data3));
    imAlpha(isnan(map_data3))=0;
    imagesc(longitude(Ilon),latitude(Ilat),map_data3,'AlphaData',imAlpha)
    set(gca,'YDir','normal')
    colormap(gca,map)
    h=colorbar;
    %ylabel(h,'SWE (m)','FontSize',20)
    caxis([0 round(10*prctile(map_data1(:),99))/10])
    if iASO==1
        title([{'Posterior SWE'} {''}])
    end
    axis equal
    set(gca,'Fontsize',24)
    xlim(xlims(iASO,:))
    ylim(ylims(iASO,:))
    set(gca, 'XTickLabel', [], 'YTickLabel', [])

    %saveas(gcf,['Post_SWE_' num2str(ASO_DOWY(iday)) '_2K.png'] )    
    
    %figure;set(gcf,'Position', [10 100 1000 750])
    iplot=iplot+1;
    axes(ha(iplot))
    map_data3=NEW_REANALYSIS_SWE_PRIOR(:,:,iday);
    if iASO==2
        load('Re_mask_WAOL')
        map_data3=NEW_REANALYSIS_SWE_PRIOR(:,:,iday).*Mask_seasonal;
        %map_data3=NEW_REANALYSIS_SWE_PRIOR(:,:,iday);
        %map_data3(map_data3>3)=nan;
    end
    %
    disp(ASO_name)
    disp('prior:')
    map_data3(nan_mask)=NaN;
    map_data3=map_data3(Ilat,Ilon);
    R=corrcoef(map_data3(:),map_data1(:),'Rows','pairwise')
    map_data3=map_data3-map_data1;
    %map_data3(nan_mask)=0;
    md=nanmean(map_data3(:))
    rmsd=sqrt(nanmean(map_data3(:).^2))
    %map_data3(isnan(map_data3))=0;
    imAlpha=ones(size(map_data3));
    imAlpha(isnan(map_data3))=0;
    imagesc(longitude(Ilon),latitude(Ilat),map_data3,'AlphaData',imAlpha)
    set(gca,'YDir','normal')
    h=colorbar;
    %ylabel(h,'SWE Difference (m)','FontSize',20)
    %colormap(gca,b2r(-0.5,0.5))
    colormap(gca, RdBl)
    caxis([-1 1])
    if iASO==1
        title([{'Prior - ASO SWE'} {''}])
    end
    set(gca,'Fontsize',24)
    axis equal
    xlim(xlims(iASO,:))
    ylim(ylims(iASO,:))
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    
    iplot=iplot+1;
    axes(ha(iplot))
    map_data3=NEW_REANALYSIS_SWE(:,:,iday);
    if iASO==2
        load('Re_mask_WAOL')
        map_data3=NEW_REANALYSIS_SWE(:,:,iday).*Mask_seasonal;
    end
    map_data3(nan_mask)=NaN;
    map_data3=map_data3(Ilat,Ilon);
    disp(ASO_name)
    disp('posterior:')
    R=corrcoef(map_data3(:),map_data1(:),'Rows','pairwise')
    map_data3=map_data3-map_data1;
    %map_data3(nan_mask)=0;
    md=nanmean(map_data3(:))
    rmsd=sqrt(nanmean(map_data3(:).^2))
    %map_data3(isnan(map_data3))=0;
    imAlpha=ones(size(map_data3));
    imAlpha(isnan(map_data3))=0;
    imagesc(longitude(Ilon),latitude(Ilat),map_data3,'AlphaData',imAlpha)
    set(gca,'YDir','normal')
    h=colorbar;
    ylabel(h,'SWE Difference (m)','FontSize',20)
    %colormap(gca,b2r(-0.5,0.5))
    colormap(gca, RdBl)
    caxis([-1 1])
    if iASO==1
        title([{'Posterior - ASO SWE'} {''}])
    end
    set(gca,'Fontsize',24)
    axis equal
    xlim(xlims(iASO,:))
    ylim(ylims(iASO,:))
    set(gca, 'XTickLabel', [], 'YTickLabel', [])

end