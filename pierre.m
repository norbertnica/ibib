dir = '/home/norbert/ibib/Pierre APP_PS1/18081317/';
filename = [dir '18081317220918003.pl2'];
channels = ["FP071", "FP080"];
%emg=fp080
%fp071 = acl1
sig = [];
x = 1;
for i = 1:length(channels)
    [adfreq, n, ts, fn, ad] = plx_ad_v(filename,char(channels(i)));
    sig(i,:) = decimate(ad,x);
end
duration = length(ad)/adfreq;
clear ad;
newfreq = adfreq/x;
ds = 1/newfreq;
t = (0:size(sig,2)-1)*ds;

tresh = [8 -8];
n = newfreq*5;

[f,ind_sleep] = find_sleep(sig(2,:),n,tresh);
time_ind_sleep = ind_sleep.*ds;
time_ind_sleep = ind_shrink2(time_ind_sleep,0.5);
ind_sleep = ind_shrink2(ind_sleep,newfreq*0.1);


sig(1,:) = lowpass(sig(1,:),250,newfreq);

%test = time_ind_split(sig(2,:),time_ind_sleep,newfreq);

[ripples, env_std, env_mean, durs, instantaneous_freqs, absolute_peaks, norm_peaks, absolute_energy, full_durs] = detect_ripples(sig(1,:)',newfreq,-1,ind_sleep,[],-1);

ripples_time = ripples.*ds;

n = newfreq*20;

[f,ind_sleep] = find_sleep(sig(2,:),n,tresh);
time_ind_sleep = ind_sleep.*ds;
time_ind_sleep = ind_shrink2(time_ind_sleep,0.5);
ind_sleep = ind_shrink2(ind_sleep,newfreq*0.1);


sig(1,:) = lowpass(sig(1,:),250,newfreq);

%test = time_ind_split(sig(2,:),time_ind_sleep,newfreq);

[ripples2, env_std, env_mean, durs, instantaneous_freqs, absolute_peaks, norm_peaks, absolute_energy, full_durs] = detect_ripples(sig(1,:)',newfreq,-1,ind_sleep,[],-1);

ripples_time2 = ripples2.*ds;

