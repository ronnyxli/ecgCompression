
clear all; close all;

% load sample file
load('mitdb_100.mat');

out = compress_ecg(t, signal(:,1), Fs);

% calculate compression ratio
CR = length(signal(:,1))/length(out.dct_coeff);

% plot results

figure;
subplot(3,1,1);
plot(out.y_norm);
grid on;
hold on;
title('Normalized ECG signal');
xlabel('Sample #');

subplot(3,1,2);
stem(out.dct_coeff, '-o');
grid on;
title('Discrete cosine transform coefficients of original ECG');
xlabel('Sample #');

% plot reconstructed signal with original
subplot(3,1,3);
title(['Compression Ratio = ' num2str(CR) ':1']);
plot(out.y_norm); hold on;
plot(out.y_new);
grid on;
legend('Original','Reconstructed');



% TODO: calculate RMSE

