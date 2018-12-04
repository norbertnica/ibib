%create directory "tree"
path1 = '/home/norbert/ibib/Pierre APP_PS1 RAW DATA FALL 2018/';
folder1 = dir(path1);
%remove first 4 entires
folder1(1:4,:) = [];
%remove last 2 entries
folder1(end-1:end,:) = [];
channels = ["FP071","FP076", "FP080"];
%channel_map = containers.Map({1,2,3},{'acl','acr','emg'});
%path to save the wav file
write_to_path = '/home/norbert/ibib/Pierre APP_PS1 RAW DATA FALL 2018/WAVS_emg_filt/';
for i = 1:length(folder1)
    %branch the directory tree to access files
    path2 = [path1 folder1(i).name '/'];
    folder2 = dir(path2);
    %remove first 4 entries
    folder2(1:4,:) = [];
    for j = 1:length(folder2)
        filename = [path2 folder2(j).name];
        sig = [];
        x = 1;
        for k = 1:length(channels)
            %actual data read, channel by channel
            [adfreq, n, ts, fn, ad] = plx_ad_v(filename,char(channels(k)));
            %downsample, in this exaple x=1 so the signal remains the same
            sig(k,:) = decimate(ad,x);
            newfreq = adfreq/x;
        end
    %scale the signal according to the max/min of the signal matrix - audiowrite function only takes values (-1,1]    
    if max(max(sig))>=abs(min(min(sig)))
        sig = sig./max(max(sig));
    else
        sig = sig./abs(min(min(sig)));
    end
    sig2 = zeros(6,size(sig,2));
    %construct final 6 channeles of the wav file: 
    % 1 - bandpass filtered fp071 between 100 and 250 (ripple band)
    % 2 - bandpass filtered fp071 between 1 and 5 (delta)
    % 3 - bandpass filtered fp071 between 5 and 10 (theta)
    % 4,5,6 - fp071, fp076, fp080(emg) highpass filtered over 100
    sig2(1,:) = bandpass(sig(1,:),[100 250],newfreq);
    sig2(2,:) = bandpass(sig(1,:),[1 5],newfreq);
    sig2(3,:) = bandpass(sig(1,:),[5 10],newfreq);
    emg_filt = highpass(sig(3,:),100,newfreq);
    sig2(4,:) = sig(1,:);
    sig2(5,:) = sig(2,:);
    sig2(6,:) = emg_filt;
    %write signal matrix to wav
    audiowrite([write_to_path erase(folder2(j).name,'.pl2') '.wav'],sig2',adfreq);
    end


end