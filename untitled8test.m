filename = '/home/norbert/ibib/Pierre_old/18081529/18081529220918001.pl2';
stagespath = '/home/norbert/ibib/stages_hm/pierre_bad/18081529220918001.txt';
[adfreq, n, ts, fn, ad] = plx_ad_v(filename,'FP071');
x = 1;
sig = decimate(ad,x);
stages = importdata(stagespath);
if isempty(stages) == 1
    ind = [0 0];
else
    ind = stages.data;
end 

sigsplitTEST = time_ind_split(sig,ind.*1/newfreq,newfreq);
totalswsTEST = [];
for i = 1:size(sigsplitTEST,1)
    totalswsTEST = [totalswsTEST;sigsplitTEST{i,2}];
end

stand = std(totalswsTEST);


STD = 0.8721;

filename2 = '/home/norbert/ibib/Pierre_old/18081529/18081529220918004.pl2';
[adfreq, n, ts, fn, ad] = plx_ad_v(filename2,'FP071');
x = 1;
sig2 = decimate(ad,x);
stagespath2 = '/home/norbert/ibib/stages_hm/pierre_bad/18081529220918004.txt';
stages2 = importdata(stagespath2);
if isempty(stages2) == 1
    ind2 = [0 0];
else
    ind2 = stages2.data;
end 

[ripples, env_std, env_mean, durs, instantaneous_freqs, absolute_peaks, ...
norm_peaks, absolute_energy, full_durs] = detect_ripples(sig2,newfreq,STD,ind2,[],-1);
time_ind = ind2.*1/newfreq;
sleep_dur = diff(time_ind,1,2);
sleep_dur = sum(sleep_dur);
z = size(ripples,1)/sleep_dur
