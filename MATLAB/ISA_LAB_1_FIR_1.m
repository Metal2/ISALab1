clear all 
close all
% definition filter order and number of bits
p=1; 
xi=7;
yi=7;

fc=2000;  %cut-off frequency
fs=10000; % sample frequency

N=2^p*(mod(xi,2)+1)+6*p; %order of the filter
n_bit=mod(yi,7)+8; % number of bits

%parameters for fir1 function
Wn=2*fc/fs; %% normalized frequency

%FIR definition
b=fir1(N,Wn);

[h1, w1]=freqz(b); %% get the transfer function of the designed filter

bi=floor(b*2^(n_bit-1)); %% convert coefficients into nb-bit integers
bq=bi/2^(n_bit-1); %% convert back coefficients as nb-bit real values
[h2, w2]=freqz(bq); %% get the transfer function of the quantized filter

%% show the transfer functions
figure(1)
plot(w1/pi, 20*log10(abs(h1))); 
hold on;
plot(w2/pi, 20*log10(abs(h2)),'r--');
grid on;
xlabel('Normalized frequency');
ylabel('dB');

%%%%%%%%%%%%%%%%%%%%%%

f1=500;  %% first sinewave freq (in band)
f2=4500; %% second sinnewave freq (out band)

dt=1/fs;


T=1/500; %% maximum period
tt=0:1/fs:10*T; %% time samples

x1=sin(2*pi*f1.*tt); %% first sinewave
x2=sin(2*pi*f2.*tt); %% second sinewave

x=(x1+x2)/2; %% input signal

y=filter(bq, 1, x); %% apply filter

%% plots
figure(2)
plot(tt,x1,'--d');
hold on
figure(3)
plot(tt,x2,'r--s');
hold on 
figure(4)
plot(tt,x, 'g--+');
hold on
figure(5)
plot(tt, y, 'c--o');

legend('x1', 'x2', 'x', 'y')

%% quantize input and output
xq=floor(x*2^(n_bit-1));
idx=find(xq==2^(n_bit-1));
xq(idx)=2^(n_bit-1)-1;

yq=floor(y*2^(n_bit-1));
idy=find(yq==2^(n_bit-1));
yq(idy)=2^(n_bit-1)-1;

%% save input and output
fp=fopen('samples.txt','w');
fprintf(fp,'%d\n', xq);
fclose(fp);

fp=fopen('resultsm.txt', 'w');
fprintf(fp, '%d\n', yq);
fclose(fp);

fp=fopen('coefficients.txt','w');
fprintf(fp,'%d\n', bi);
fclose(fp);


thd_output=thd(yq);
thd_inputs=thd(xq);



