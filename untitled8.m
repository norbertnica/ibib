%FIND STANDARD DEVIATIONS
stagespath1 = '/home/norbert/ibib/stages_hm/pierre_bad/';
stagesfolder1 = dir(stagespath1);
stagesfolder1(1:2) = [];
path1 = '/home/norbert/ibib/Pierre_old/';
folder1 = dir(path1);
folder1(1:2) = [];
folder1(end-1:end) = [];
animals = {'18072636','18081529','18080343','18081317','18081426','18080838','18080730'};
bbexamap = containers.Map(animals,...
    {'18072636240918','18081529220918','18080343210918','18081317220918','18081426200918',...
    '18080838200918','18080730190918'});
sdmap = containers.Map('KeyType','char','ValueType','double');
results = {};
for i = 1:length(folder1)
    stagespath2 = [stagespath1 bbexamap(folder1(i).name) '00'];
    n = 0;
    stages = [];
    while(isempty(stages)==1)
        n = n+1;
        stages = importdata([stagespath2 int2str(n) '.txt']);
    end
    ind = stages.data;
    filename = [path1 folder1(i).name '/' bbexamap(folder1(i).name) '00' int2str(n) '.pl2'];
    [adfreq, n, ts, fn, ad] = plx_ad_v(filename,'FP071');
    x = 1;
    sig = decimate(ad,x);
    newfreq = adfreq/x;
    %ind
    sigsplit = time_ind_split(sig,ind.*1/newfreq,newfreq);
    totalsws = sigsplit{:,2};
    sd = std(totalsws);
    sdmap(folder1(i).name) = sd;
end
save('sdmap.mat','sd');
%COUNT RIPPLES
stagespath1 = '/home/norbert/ibib/stages_hm/pierre_bad/';
stagesfolder1 = dir(stagespath1);
stagesfolder1(1:2) = [];
path1 = '/home/norbert/ibib/Pierre_old/';
folder1 = dir(path1);
folder1(1:2) = [];
folder1(end-1:end) = [];
channel = 'FP071';
k = 1;
for i = 1:length(folder1)
    %branch the directory tree to access files
    path2 = [path1 folder1(i).name '/'];
    folder2 = dir(path2);
    %remove first two entries
    folder2(1:4,:) = [];
    for j = 1:length(folder2)
        filename = [path2 folder2(j).name];
        [adfreq, n, ts, fn, ad] = plx_ad_v(filename,channel);
        x = 1;
        sig = decimate(ad,x);
        newfreq = adfreq/x;
        txt = [erase(folder2(j).name,'.pl2') '.txt'];
        stages = importdata([stagespath1 txt]);
        %stages
        if isempty(stages) == 1
            ind = [0 0];
        else
            ind = stages.data;
        end 
        [ripples, env_std, env_mean, durs, instantaneous_freqs, absolute_peaks, ...
        norm_peaks, absolute_energy, full_durs] = detect_ripples(sig,newfreq,sdmap(folder1(i).name),ind,[],-1);
        time_ind = ind.*1/newfreq;
        sleep_dur = diff(time_ind,1,2);
        sleep_dur = sum(sleep_dur);
        z = size(ripples,1)/sleep_dur;
        results{k,1} = folder2(j).name;
        results{k,2} = z;
        
        k = k+1;
    end
end
