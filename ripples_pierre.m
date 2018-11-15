path_before = '/home/norbert/ibib/Pierre APP_PS1/selected/before_learning/';
path_after = '/home/norbert/ibib/Pierre APP_PS1/selected/after_learning/';
channels = ["FP071", "FP080"];
folder_before = dir(path_before);
folder_before(1:2) = [];
folder_after = dir(path_after);
folder_after(1:2) = [];
b_ripples = zeros(length(folder_before),1);
b_cell = cell(length(folder_before),4);
b_sleep = zeros(length(folder_before),1);
a_ripples = zeros(length(folder_after),1);
a_sleep = zeros(length(folder_after),1);
a_cell = cell(length(folder_after),4);
%189 i 275
for i = 1:length(folder_before)
    name = folder_before(i).name;
    filename = [path_before name];
    sig = [];
    x = 1;
    for j = 1:length(channels)
        [adfreq, ~, ts, fn, ad] = plx_ad_v(filename,char(channels(j)));
        sig(j,:) = decimate(ad,x);
    end
    duration = length(ad)/adfreq;
    clear ad;
    newfreq = adfreq/x;
    ds = 1/newfreq;
    t = (0:size(sig,2)-1)*ds;
    tresh = [8 -8];
    n = newfreq*15;
    [f,ind_sleep] = find_sleep(sig(2,:),n,tresh);
    ind_sleep = ind_shrink2(ind_sleep,newfreq*0.1);
    time_ind_sleep = ind_sleep.*ds;
    sleep_dur = diff(time_ind_sleep,1,2);
    sleep_dur = sum(sleep_dur);
    sig(1,:) = lowpass(sig(1,:),250,newfreq);
    [ripples, env_std, env_mean, durs, instantaneous_freqs, absolute_peaks, ...
        norm_peaks, absolute_energy, full_durs] = detect_ripples(sig(1,:)',newfreq,-1,ind_sleep,[],-1);
    b_ripples(i,1) = size(ripples,1);
    b_sleep(i,1) = size(ind_sleep,1);
    b_cell{i,1} = name;
    b_cell{i,2} = b_ripples(i,1);
    b_cell{i,3} = sleep_dur;
    b_cell{i,4} = b_ripples(i,1)/sleep_dur;

  
end

for i = 1:length(folder_after)
    name = folder_after(i).name;
    filename = [path_after name];
    sig = [];
    x = 1;
    for j = 1:length(channels)
        [adfreq, ~, ts, fn, ad] = plx_ad_v(filename,char(channels(j)));
        sig(j,:) = decimate(ad,x);
    end
    duration = length(ad)/adfreq;
    clear ad;
    newfreq = adfreq/x;
    ds = 1/newfreq;
    t = (0:size(sig,2)-1)*ds;
    tresh = [8 -8];
    n = newfreq*15;
    [f,ind_sleep] = find_sleep(sig(2,:),n,tresh);
    time_ind_sleep = ind_sleep.*ds;
    time_ind_sleep = ind_shrink2(time_ind_sleep,0.5);
    ind_sleep = ind_shrink2(ind_sleep,newfreq*0.1);
    time_ind_sleep = ind_sleep.*ds;
    sleep_dur = diff(time_ind_sleep,1,2);
    sleep_dur = sum(sleep_dur);
    sig(1,:) = lowpass(sig(1,:),250,newfreq);
    [ripples, env_std, env_mean, durs, instantaneous_freqs, absolute_peaks, ...
        norm_peaks, absolute_energy, full_durs] = detect_ripples(sig(1,:)',newfreq,-1,ind_sleep,[],-1);
    a_ripples(i,1) = size(ripples,1);
    a_sleep(i,1) = size(ind_sleep,1);
    a_cell{i,1} = name;
    a_cell{i,2} = a_ripples(i,1);
    a_cell{i,3} = sleep_dur;
    a_cell{i,4} = a_ripples(i,1)/sleep_dur;
  
end
a_table = cell2table(a_cell);
b_table = cell2table(b_cell);

%calkowita dlugosc swsow