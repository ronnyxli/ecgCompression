
function [out] = compress_ecg(t, y, fs)

ENERGY_THRESH = 0.90;

% zero-mean, then normalize by max
y_zm = y - mean(y);
y_norm = y_zm/max(abs(y_zm));

% DCT of ECG - return coefficients
y_dct = dct(y_norm);

% determine coefficients that make up ENERGY_THRESH% of energy
y_dct_cum = cumsum(abs(y_dct));
energy_thresh = y_dct_cum(end)*ENERGY_THRESH;
y_dct_selected = y_dct(y_dct_cum < energy_thresh);

% scale coefficients by minimum to get all positive numbers
dct_shift = max(abs(y_dct_selected));
y_dct_scaled = y_dct_selected + dct_shift;

% TODO: quantize coefficients

y_dct_final = y_dct_scaled;

% zero-padding
y_dct_recon = y_dct_final - dct_shift;
pad_vec = zeros(length(y) - length(y_dct_final),1);
y_dct_new = [y_dct_recon; pad_vec];

% inverse DCT (reconstructed signal)
out.y_new = idct(y_dct_new);

out.dct_coeff = y_dct_final;
out.dct_shift = dct_shift;

out.y_norm = y_norm;

