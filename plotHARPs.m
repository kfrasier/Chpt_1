%% Takes gridded SST data and plots western North Atlantic region with HARP locations on top

% Load data from NetCDF file:
SST = ncread('A20190602019090.L3m_MO_SST_sst_4km.nc','sst');
Lat = ncread('A20190602019090.L3m_MO_SST_sst_4km.nc','lat');
Long = ncread('A20190602019090.L3m_MO_SST_sst_4km.nc','lon');

[Lon_mat Lat_mat] = meshgrid(Long,Lat);
SST = SST';

imagesc(SST)

% Trim data to western N Atl:
[maxlatval maxlat] = min(abs(Lat-47));
[minlatval minlat] = min(abs(Lat-22));
[maxlonval maxlon] = min(abs(Long+85));
[minlonval minlon] = min(abs(Long+60));

Atl_sst = SST(maxlat:minlat, maxlon:minlon);
Atl_lat = Lat(maxlat:minlat);
Atl_lon = Long(maxlon:minlon);

% Atl Harp sites
sites = {'HZ', 'OC', 'NC', 'BC', 'WC', 'NFC', 'HAT', 'GS', 'BP', 'BS', 'JAX'};
HARPs = [41.06165 66.35155;  % WAT_HZ
    40.22999 67.97798;       % WAT_OC
    39.83295 69.98194;       % WAT_NC
    39.19192 72.22735;       % WAT_BC
    38.37337 73.36985;       % WAT_WC
    37.16452 74.46585;       % NFC
    35.30183 74.87895;       % HAT
    33.66992 75.9977;        % WAT_GS
    32.10527 77.09067;       % WAT_BP
    30.58295 77.39002;       % WAT_BS
    30.27818 80.22085];      % JAX

% Find HARP indices in lat/lon vecs
ind = [];
for i = 1:size(HARPs,1)
    [q ind1] = min(abs(Atl_lat-HARPs(i,1)));
    [q ind2] = min(abs(Atl_lon+HARPs(i,2)));
    ind = [ind;ind1 ind2];
end

figure
colormap jet
clims = [0 35];
deg = char(176);
imagesc(Atl_sst,clims);
h = colorbar
hold on
plot(ind(1:5,2),ind(1:5,1),'pk','MarkerFaceColor','m','MarkerSize',13);
plot(ind(6:7,2),ind(6:7,1),'pk','MarkerFaceColor','y','MarkerSize',13);
plot(ind(8:11,2),ind(8:11,1),'pk','MarkerFaceColor','c','MarkerSize',13);
hold off
xlabel('Longitude');
ylabel('Latitude');
ylabel(h,['SST (' deg 'C)']);
yticks([49 169 289 409 529]);
yticklabels({['45' deg],['40' deg],['35' deg], ['30' deg], ['25' deg]})
xticks([121 241 361 481 601]);
xticklabels({['80' deg],['75' deg],['70' deg], ['65' deg], ['60' deg]})
title({'Atlantic Passive', 'Acoustic Monitoring Sites'});
set(gca,'fontSize',25);
%title('MODIS Monthly Average SST: March 2019');
for i = 1:size(sites,2)
    if i >= 1 && i <= 5
        text(ind(i,2),ind(i,1),['  ' sites{i}],'FontSize',16,'color','m','FontWeight','bold');
    elseif i >= 6 && i <= 7
        text(ind(i,2),ind(i,1),['  ' sites{i}],'FontSize',16,'color','r','FontWeight','bold');
    elseif i >= 8 && i <= 11
        text(ind(i,2),ind(i,1),['  ' sites{i}],'FontSize',16,'color','b','FontWeight','bold');
    end
end

saveas(gcf,'Atl_HARP_Sites','tiff');
