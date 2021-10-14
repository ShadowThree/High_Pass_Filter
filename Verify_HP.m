clear,clc,close all;    % 清除之前的计算记录

PROCESS_CONTROL_FLAG = 2;

N = 8000;
Fs = 8000;
t = 0:1/Fs:1-1/Fs;

raw_data = 15000*sin(2*pi*t) + 5000*sin(2*pi*100*t) + 5000;

if PROCESS_CONTROL_FLAG == 0
    % 生成需要滤波的原始数据
    NUM_TAPS = 100;
    pre_zero = zeros(1, NUM_TAPS);

    fid = fopen('./sin_data.h', 'wt');
    fprintf(fid, '#include <inttypes.h>\r\n');
    fprintf(fid, '#define SAMPLE_DATA_LEN   %d\n', N);
    fprintf(fid, '#define NUM_TAPS          %d\r\n', NUM_TAPS);
    fprintf(fid, 'static float sin_data[%d] = {\n', N + NUM_TAPS);
    fprintf(fid, '%g, ', pre_zero);
    fprintf(fid, '%g, ', raw_data);     % 最后一个数据多了一个逗号，需要手动删除
    fprintf(fid, '\n};');

    fprintf(fid, '\r\n');
    %h = fir1(NUM_TOPS, 10/(Fs/2), 'high');
    h = load('HP_100taps_FIR_coeff.fcf');
    %length(h)
    fprintf(fid, 'const float coeff[%d] = {\n', NUM_TAPS + 1);
    fprintf(fid, '%+.10ff, ', h);       % 最后一个数据多了一个逗号，需要手动删除
    fprintf(fid, '\n};');

    fclose(fid);
end

if PROCESS_CONTROL_FLAG == 1
    % 处理滤波后的数据
    HP_data = load('result.txt');

    subplot(2,2,1);
    plot(0:N-1, raw_data);
    title('sin data');
    xlabel('N');
    ylabel('Amplitude');

    subplot(2,2,3);
    plot(0:N-1, HP_data);
    title('HP data');
    xlabel('N');
    ylabel('Amplitude');

    f = (0:N-1)*Fs/N;
    raw_fft = abs(fft(raw_data));
    subplot(2,2,2);
    plot(f, raw_fft/(N/2));
    title('raw fft');
    xlabel('Freq');
    ylabel('Amplitude');

    HP_fft = abs(fft(HP_data));
    subplot(2,2,4);
    plot(f, HP_fft/(N/2));
    title('HP fft');
    xlabel('Freq');
    ylabel('Amplitude');
end

if PROCESS_CONTROL_FLAG == 2
    % 对 MCU 滤波的数据进行验证
    acc_LEN = 8032;
    acc_data = csvread('./HP_tap100_result.csv', 1, 0, [1,0,acc_LEN,0]);   % count start from 0
    acc_after_HP = csvread('./HP_tap100_result.csv', 1, 3, [1,3,acc_LEN,3]);
    
    subplot(2,2,1);
    plot(0:acc_LEN-1, acc_data);
    title('acc data');
    xlabel('N');
    ylabel('Amplitude');
    
    f = 0:acc_LEN-1;
    acc_fft = abs(fft(acc_data))/(acc_LEN/2);
    subplot(2,2,2);
    plot(f, acc_fft);
    title('acc data after fft');
    xlabel('Freq');
    ylabel('Amplitude');
    
    subplot(2,2,3);
    plot(0:acc_LEN-1, acc_after_HP);
    title('acc data after HP filter');
    xlabel('N');
    ylabel('Amplitude');
    
    acc_after_HP_fft = abs(fft(acc_after_HP))/(acc_LEN/2);
    subplot(2,2,4);
    plot(f, acc_after_HP_fft);
    title('fft for acc data after HP filter');
    xlabel('Freq');
    ylabel('Amplitude');
end
