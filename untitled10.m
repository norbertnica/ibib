load('sdmap2.mat');
channel = 'FP071';
stagespath1 = '/home/norbert/ibib/stages_hm/pierre_bad/';
path1 = '/home/norbert/ibib/Pierre_old/18081317/';
rec = '18081317220918002.pl2';
[adfreq, nn, ts, fn, ad] = plx_ad_v([path1 rec],channel);
x = 1;
sig = decimate(ad,x);
newfreq = adfreq/x;
%sig = bandpass(sig,[100 250],newfreq);
stop_att = 40;
[z,p,k] = cheby2(4,stop_att,[100/500 250/500],'bandpass');
[sos,g] = zp2sos(z,p,k);
sig = filtfilt(sos,g,sig);
txt = [erase(rec,'.pl2') '.txt'];
stages = importdata([stagespath1 txt;]);
%stages
if isempty(stages) == 1
    ind = [0 0];
else
    ind = stages.data;
end
sd = 0.16
[ripples, env_std, env_mean, durs, instantaneous_freqs, absolute_peaks, ...
        norm_peaks, absolute_energy, full_durs] = detect_ripples(sig,newfreq,sd,ind,[],1);
    
time_ind = ind.*1/newfreq;
tot = sum(diff(time_ind,1,2));

 sig = abs(hilbert(sig));
 sig_sws = [];
 for i = 1:size(stages.data,1)
     sig_sws = [sig_sws;sig(stages.data(i,1):stages.data(i,2))];
 end