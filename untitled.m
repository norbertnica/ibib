dir = '/media/norbert/LaCie/APP_PS1/Maze 8 arms/160214/';
filename = [dir '160214_16-05-02_16-33_1.pl2'];
[adfreq, n, ts, fn, ad] = plx_ad_v(filename,'WB016');
duration = length(ad)/adfreq;
x = 50;
newfreq = adfreq/x;

sig = decimate(ad,x);

ds = 1/newfreq;

time = (0:length(sig)-1)*ds;


sws1 = sig(1:11/ds);
awake1 = sig(24/ds:36/ds);

sws1 = detrend(sws1);
awake1 = detrend(awake1);


%%%a to skurwysyny


sws1_f = fft(sws1);
awake1_f = fft(awake1);

freqs_sws1 = (0:length(sws1_f)/2).*newfreq/length(sws1_f);
sws1_power = 2*(abs(sws1_f(1:(length(sws1_f)/2)+1)).^2)/length(sws1_f);

figure;
plot(freqs_sws1,sws1_power);

freqs_awake1 = (0:length(awake1_f)/2).*newfreq/length(awake1_f);
awake1_power = 2*(abs(awake1_f(1:(length(awake1_f)/2)+1)).^2)/length(awake1_f);

figure;
plot(freqs_awake1,awake1_power);


[val_aw,ind_aw] = max(awake1_power);
[val_sws,ind_sws] = max(sws1_power);
fmax_sws = freqs_sws1(ind_sws);
fmax_awake = freqs_awake1(ind_aw);
val_sws;
val_aw;

e_tot_sws = sum(sws1_power)
e_tot_awake = sum(awake1_power)

scatter([fmax_sws fmax_awake],[val_sws val_aw])

[85 110]
[187 203]

sws2 = sig(85/ds:110/ds);
awake2 = sig(187/ds:203/ds);

sws2 = detrend(sws2);
awake2 = detrend(awake2);

sws2_f = fft(sws2);
awake2_f = fft(awake2);

freqs_sws2 = (0:length(sws2_f)/2).*newfreq/length(sws2_f);
sws2_power = 2*(abs(sws2_f(1:(length(sws2_f)/2)+1)).^2)/length(sws2_f);

figure;
plot(freqs_sws2,sws2_power);

freqs_awake2 = (0:length(awake2_f)/2).*newfreq/length(awake2_f);
awake2_power = 2*(abs(awake2_f(1:(length(awake2_f)/2)+1)).^2)/length(awake2_f);

figure;
plot(freqs_awake2,awake2_power);


[val_aw2,ind_aw2] = max(awake2_power);
[val_sws2,ind_sws2] = max(sws2_power);
fmax_sws2 = freqs_sws2(ind_sws2);
fmax_awake2 = freqs_awake2(ind_aw2);
val_sws2;
val_aw2;

e_tot_sws2 = sum(sws2_power)
e_tot_awake2 = sum(awake2_power)


scatter([fmax_sws fmax_awake fmax_sws2 fmax_awake2],[val_sws val_aw val_sws2 val_aw2])