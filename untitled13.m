stagespath1 = '/home/norbert/ibib/stages_hm/pierre_bad/';
stagesfolder1 = dir(stagespath1);
stagesfolder1(1:2) = [];
path1 = '/home/norbert/ibib/Pierre_old/';
folder1 = dir(path1);
folder1(1:2) = [];
folder1(end-1:end) = [];
channel = 'FP071';
animals = {'18072636','18081529','18080343','18081317','18081426','18080838','18080730'};
bbexamap = containers.Map(animals,...
    {'18072636240918','18081529220918','18080343210918','18081317220918','18081426200918',...
    '18080838200918','18080730190918'});
abexamap = containers.Map(animals,...
    {'18072636221018','18081529191018','18080343191018','18081317181018','18081426171018',...
    '18080838161018','18080730151018'});
sdmapbbexa = containers.Map('KeyType','char','ValueType','double');
sdmapabexa = containers.Map('KeyType','char','ValueType','double');

for i = 1:length(folder1)
    stagespath2 = [stagespath1 bbexamap(folder1(i).name) '00'];
    path2 = [path1 folder1(i).name '/' bbexamap(folder1(i).name) '00'];
    n = 1;
    totalsws = [];
    while true
        if n>9
            path2 = [path1 folder1(i).name '/' bbexamap(folder1(i).name) '0'];
        end
        if strcmp(folder1(i).name,'18080343') == 1
            n = n+1;
        end
        filename = [path2 int2str(n) '.pl2'];
        is = isfile(filename);
        if is == 0
            n
            break;
        end
        [adfreq, nn, ts, fn, ad] = plx_ad_v(filename,channel);
        x = 1;
        sig = decimate(ad,x);
        newfreq = adfreq/x;
        %sig = bandpass(sig,[100 250],newfreq);
        %ind
        stop_att = 40;
        [z,p,k] = cheby2(4,stop_att,[100/500 250/500],'bandpass');
        [sos,g] = zp2sos(z,p,k);
        sig = filtfilt(sos,g,sig);
        sig = abs(hilbert(sig));
        stages = importdata([stagespath2 int2str(n) '.txt']);
        %stages
        if isempty(stages) == 1
            ind = [1 1];
        else
            ind = stages.data;
        end 
        if ind(1,1) == 0
            ind(1,1) = 1;
        end
        sigsplit = time_ind_split(sig,ind.*1/newfreq,newfreq);
        for k = 1:size(sigsplit,1)
            totalsws = [totalsws;sigsplit{k,2}];
        end
        n = n+1;
    end
    sd = std(totalsws);
    sdmapbbexa(folder1(i).name) = sd;
end
