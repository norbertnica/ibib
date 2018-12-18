stagespath1 = '/home/norbert/ibib/stages_hm/pierre_bad/';
stagesfolder1 = dir(stagespath1);
stagesfolder1(1:2) = [];
path1 = '/home/norbert/ibib/Pierre_old/';
folder1 = dir(path1);
folder1(1:2) = [];
folder1(end-1:end) = [];
channel = 'FP071';
k = 1;
sdmap = containers.Map('KeyType','char','ValueType','double');
for i = 1:length(folder1)
    %branch the directory tree to access files
    path2 = [path1 folder1(i).name '/'];
    folder2 = dir(path2);
    %remove first two entries
    folder2(1:4,:) = [];
    totalsws = [];
    for j = 1:length(folder2)
        filename = [path2 folder2(j).name];
        [adfreq, nn, ts, fn, ad] = plx_ad_v(filename,channel);
        x = 1;
        sig = decimate(ad,x);
        newfreq = adfreq/x;
        sig = bandpass(sig,[100 250],newfreq);
        sig = abs(hilbert(sig));
        txt = [erase(folder2(j).name,'.pl2') '.txt'];
        stages = importdata([stagespath1 txt]);
        %stages
        if isempty(stages) == 1
            ind = [0 0];
        else
            ind = stages.data;
        end 
        sigsplit = time_ind_split(sig,ind.*1/newfreq,newfreq);
        for k = 1:size(sigsplit,1)
            totalsws = [totalsws;sigsplit{k,2}];
        end
    end
    sd = std(totalsws);
    sdmap(folder1(i).name) = sd; 
end
save('sdmap3.mat','sdmap');