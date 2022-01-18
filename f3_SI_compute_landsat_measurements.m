% create # measurements large matrix
%% Initialize the matrix
addpath(genpath('/Users/yiwenff/Desktop/SWE_reanalysis_preprocessing/github_testing/SWE_reanalysis_pre_and_post_processing-master'))

pathname1='/Volumes/columbia_hd6/BACKUPS/hydro2_external_RAID2/PROJECTS/SWE_REANALYSIS/WUS/INPUT_DATA/';
pathname='/Volumes/columbia_hd6/BACKUPS/hydro2_external_RAID2/PROJECTS/SWE_REANALYSIS/WUS/INPUT_DATA/INPUT_FILES/';
addpath(genpath(pathname))
agg='16';

lon_map_array = [-125:-102]; lat_map_array = [49:-1:31]; % updated 01/30/2020

lon_map_array_480 = lon_map_array(1)+1/225/2:1/225:lon_map_array(end)+1-1/225/2;
lat_map_array_480 = lat_map_array(1)+1-1/225/2:-1/225:lat_map_array(end)+1/225/2;

load /Users/yiwenff/Desktop/SWE_reanalysis_preprocessing/github_testing/SWE_reanalysis_pre_and_post_processing-master/COORDS_WUS.mat
COORDS=[COORDS_high_elev;COORDS_low_elev];
WYs=[1992, 2002, 2012, 2018];
nyears=length(WYs);
MEAS_NUM = nan(225*length(lat_map_array),225*length(lon_map_array),nyears);
for iyear=1:length(WYs)
    disp(['Process WY' num2str(WYs(iyear))])
    WY_text=num2str(WYs(iyear));
    % New SWE reanalysis files
    WY1_string=num2str(str2num(WY_text)-1);
    WY2_string=WY_text(end-1:end);
    WY_string=[WY1_string '_' WY2_string];
    
    for i_tile=1:length(COORDS)
        meas_matrix=nan(225,225);
        coords=COORDS(i_tile,:);
        % Create lat/lon labels for this coordinate
        [appendlon, appendlat, append_val_lat, append_val_lon] = coord_process(coords);
        coord_var = [appendlat num2str(floor(abs(coords(1)))) append_val_lat appendlon num2str(floor(abs(coords(2)))) append_val_lon];
        if exist([pathname '/' coord_var '_agg_' agg '/' coord_var '_agg_' agg '_WY_' WY_string '_nmeas.in'])==0
            disp ([coord_var ' does not has file'])
        else
            new_landsat_meas=load([pathname '/' coord_var '_agg_' agg '/' coord_var '_agg_' agg '_WY_' WY_string '_nmeas.in']);
            %if length(new_landsat_meas)~=50625
            %    disp([ coord_var ' has ' num2str(length(new_landsat_meas)) ' of pixels'])
            %else
            inds=new_landsat_meas(:,1);
            meas_matrix(inds)=new_landsat_meas(:,2);
            
            i_lon = find(lon_map_array==coords(1,2));
            i_lat = find(lat_map_array==coords(1,1));
            lat_start = 225*i_lat-224; lat_end = 225*i_lat;
            lon_start = 225*i_lon-224; lon_end = 225*i_lon;
            if ~isempty(i_lon) & ~isempty(i_lat)
                MEAS_NUM(lat_start:lat_end,lon_start:lon_end,iyear) = meas_matrix;
            else
                disp('    this tile is outside the bounds')
            end
        end
    end
end
save('Landsat_meas_data','MEAS_NUM','WYs','lon_map_array_480','lat_map_array_480')