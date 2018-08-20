
function [out] = compress_ecg(t, y, fs)

ENERGY_THRESH = 0.90;

% zero-mean, then normalize by max
y_zm = y - mean(y);
y_norm = y_zm/max(abs(y_zm));

figure;
subplot(3,1,1);
plot(y_norm);
grid on;
hold on;
title('Normalized ECG signal');
xlabel('Sample #');

% DCT of ECG return coefficients
y_dct = dct(y_norm);

% determine coefficients that make up ENERGY_THRESH% of energy
y_dct_cum = cumsum(abs(y_dct));
energy_thresh = y_dct_cum(end)*ENERGY_THRESH;
y_dct_selected = y_dct(y_dct_cum < energy_thresh);

% scale coefficients by minimum
dct_shift = max(abs(y_dct_selected));
y_dct_scaled = y_dct_selected + dct_shift;

% TODO: quantize coefficients

y_dct_final = y_dct_scaled;

% compression ratio
CR = length(y_norm)/length(y_dct_final);

subplot(3,1,2);
stem(y_dct_final, '-o');
grid on;
title('Discrete cosine transform coefficients of original ECG');
xlabel('Sample #');

% zero-padding
y_dct_recon = y_dct_final - dct_shift;
pad_vec = zeros(length(y) - length(y_dct_final),1);
y_dct_new = [y_dct_recon; pad_vec];

% inverse DCT
y_new = idct(y_dct_new);

% plot reconstructed signal with original
subplot(3,1,3);
title(['Compression Ratio = ' num2str(CR) ':1']);
plot(y_norm); hold on;
plot(y_new);
grid on;
legend('Original','Reconstructed');

out.dct_coeff = y_dct_final;

