dir = '/media/norbert/LaCie/APP_PS1/Maze 8 arms/160214/';
filename = [dir '160214_16-05-02_17-55_2.pl2'];
[adfreq, n, ts, fn, ad] = plx_ad_v(filename,'WB004');
duration = length(ad)/adfreq;
x = 50;
newfreq = adfreq/x;

sig = decimate(ad,x);

ds = 1/newfreq;

time = (0:length(sig)-1)*ds;

sws = sig(295*newfreq:406*newfreq);
rem = sig(1498*newfreq:1639*newfreq);

f_sws = (abs(2.*fft(sws)./length(sws))).^2;
fh_sws = f_sws(1:floor(length(sws)/2));
sws_freq = (1:floor(length(sws)/2)).*newfreq/length(sws);

f_rem = (abs(2.*fft(rem)./length(rem))).^2;
fh_rem = f_rem(1:floor(length(rem)/2));
rem_freq = (1:floor(length(rem)/2)).*newfreq/length(rem);



delta_sws = sum(fh_sws(int16(1:5*length(sws)/newfreq)))
theta_sws = sum(fh_sws(int16(5*length(sws)/newfreq:10*length(sws)/newfreq)))

delta_rem = sum(fh_rem(int16(1:5*length(rem)/newfreq)))
theta_rem = sum(fh_rem(int16(5*length(rem)/newfreq:10*length(rem)/newfreq)))


round(5*length(sws)/newfreq):round(10*length(sws)/newfreq)