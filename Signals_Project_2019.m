pkg load signal     %for the findpeaks() fn.

%Global Variables:
t_Length = 2;       %2 second clip
fs = 44100;         %Sampling Frequency
f1 = 500;           %Fundamental Frequency
fc = 1250;          %Cutoff Frequency for BW filters
N = floor(fs/f1);   %No. of Samples per Cylcle

t = 0 : 1/fs : t_Length;
f = linspace(-fs/2 , fs/2 , fs*t_Length+1);


%Main:

%x(t)
x = cos(2*pi*f1*t) + cos(2*pi*2*f1*t) + cos(2*pi*3*f1*t) + cos(2*pi*4*f1*t);

audiowrite('x(t).wav',x,fs);
sound(x,fs);

figure('Name','Input Signal in Time Domain');
plot(t(1:4*N),x(1:4*N)) %Plot 4 cycles Only
title('Input Signal in Time Domain')
xlabel('t')
ylabel('x(t)')

P_x = 1/N * sum(abs(x(N:2*N-1)).^2)

%X(f)
X = fftshift(fft(x))/fs;

figure('Name','Input Signal in Frequency Domain');
plot(f,abs(X))
title('Input Signal in Frequency Domain')
xlabel('f')
ylabel('X(f)')

C_k_X = findpeaks(abs(X)(fs:end),"MinPeakHeight",0.1);
P_X = sum(C_k_X.^2)/2

%Butterwoth LPF
[low_b,low_a] = butter(10,fc/(fs/2),'low');

figure('Name','Frequency Response of LPF');
freqz(low_b,low_a)

%y1(t)
y1 = filtfilt(low_b,low_a,x);

audiowrite('y1(t).wav',y1,fs);
sound(y1,fs);

figure('Name','LPF Signal in Time Domain');
plot(t(1:4*N),y1(1:4*N)) %Plot 4 cycles Only
title('LPF Signal in Time Domain')
xlabel('t')
ylabel('y1(t)')

P_y1 = 1/N * sum(abs(y1(N:2*N-1)).^2)

%Y1(f)
Y1 = fftshift(fft(y1))/fs;

figure('Name','LPF Signal in Frequency Domain');
plot(f,abs(Y1))
title('LPF Signal in Frequency Domain')
xlabel('f')
ylabel('Y1(f)')

C_k_Y1 = findpeaks(abs(Y1)(fs:end),"MinPeakHeight",0.1);
P_Y1 = sum(C_k_Y1.^2)/2

%Butterwoth HPF
[high_b,high_a] = butter(10,fc/(fs/2),'high');

figure('Name','Frequency Response of HPF');
freqz(high_b,high_a)

%y2(t)
y2 = filtfilt(high_b,high_a,x);

audiowrite('y2(t).wav',y2,fs);
sound(y2,fs);

figure('Name','HPF Signal in Time Domain');
plot(t(1:4*N),y2(1:4*N)) %Plot 4 cycles Only
title('HPF Signal in Time Domain')
xlabel('t')
ylabel('y2(t)')

P_y2 = 1/N * sum(abs(y2(N:2*N-1)).^2)

%Y2(f)
Y2 = fftshift(fft(y2))/fs;

figure('Name','HPF Signal in Frequency Domain');
plot(f,abs(Y2))
title('HPF Signal in Frequency Domain')
xlabel('f')
ylabel('Y2(f)')

C_k_Y2 = findpeaks(abs(Y2)(fs:end),"MinPeakHeight",0.1);
P_Y2 = sum(C_k_Y2.^2)/2