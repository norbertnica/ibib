%WCZYTANIE
dir = '/media/norbert/LaCie/APP_PS1/Maze 8 arms/160217/';
filename = [dir '160217_16-05-03_10-54_4.pl2'];
channels = ["WB007","WB012", "WB016"];
channel_map = containers.Map({1,2,3},{'acl','acr','emg'});
sig = [];
x = 50;
for i = 1:length(channels)
    [adfreq, n, ts, fn, ad] = plx_ad_v(filename,char(channels(i)));
    sig(i,:) = decimate(ad,x);
end
duration = length(ad)/adfreq;
clear ad;
newfreq = adfreq/x;
ds = 1/newfreq;

t = (0:size(sig,2)-1)*ds;

%TRESHOLD
tresh = [0.35 -0.35];
n = newfreq*10;

[f,ind_sleep] = find_sleep(sig(3,:),n,tresh);
time_ind_sleep = ind_sleep.*ds;
time_ind_sleep = ind_shrink2(time_ind_sleep,0.5);

test = time_ind_split(sig(2,:),time_ind_sleep,newfreq);

x = test{1,2};
n = 1*newfreq;
rows = ceil(size(x,2)/n);

size(x,2)/newfreq;

theta_power = power_in_band2(test,2,newfreq,[5 10]);
delta_power = power_in_band2(test,2,newfreq,[0.5 5]);

cell_size = sum(cellfun('length',theta_power));
vec = zeros(cell_size,1);
v = [];
t = [];
for i = 1:length(theta_power)
    v = [v ; theta_power{i,1}(:,1), delta_power{i,1}(:,1)];
end
for i = 1:length(theta_power)
    t = [t ; theta_power{i,1}(:,2:3)];
end

v(:,3) = v(:,1)./v(:,2);
z = v(:,3);
scatter(v(:,2),v(:,2));
scatter(v(:,1),v(:,1));
scatter(v(:,3),v(:,3));
p = prctile(v(:,3),95);
figure;
hold on;
scatter(z,z);
plot([p p],[min(z) max(z)]);
hold off;
pz = z>p;
rem = z>1;
rem2 = v(:,1)>v(:,2);
tpz = t.*pz;
scatter(v(:,1),v(:,2));
%SPROBUMY ODFILTROWAC