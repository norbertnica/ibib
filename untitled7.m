stagespath = '/home/norbert/ibib/stages_hm/pierre_bad/';
stagesfolder = dir(stagespath);
stagesfolder(1:2) = [];
path1 = '/home/norbert/ibib/Pierre_old/';
folder1 = dir(path1);
folder1(1:2) = [];
folder1(end-1:end) = [];
channel = 'FP071';
for i = 1:length(folder1)
    %branch the directory tree to access files
    path2 = [path1 folder1(i).name '/'];
    folder2 = dir(path2);
    %remove first two entries
    folder2(1:2,:) = [];
    for j = 1:length(folder2)
        filename = [path2 folder2(j).name];
        [adfreq, n, ts, fn, ad] = plx_ad_v(filename,channel);
        x = 1;
        sig = decimate(ad,x);
        newfreq = adfreq/x;
        txt = [erase(folder2(j).name,'.pl2') '.txt'];
        stages = importdata([stagespath txt]);
        %stages
        if isempty(stages) == 1
            ind = [0 0];
        else
            ind = stages.data;
        end    
        
        [ripples, env_std, env_mean, durs, instantaneous_freqs, absolute_peaks, ...
        norm_peaks, absolute_energy, full_durs] = detect_ripples(sig,newfreq,-1,ind,[],-1);
        time_ind = ind.*1/newfreq;
        sleep_dur = diff(time_ind,1,2);
        sleep_dur = sum(sleep_dur);
        size(ripples,1)/sleep_dur
    end
end
