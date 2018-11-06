
function [y_recon, b_recon] = decompress(b, b_lim, zeroIdx, params)

QUANT_PRECISION = params.QUANT_PRECISION;

b_recon = zeros(1,length(zeroIdx));

counter = 1;
quant_range = linspace(-2^(QUANT_PRECISION-1),2^(QUANT_PRECISION-1)-1,2^QUANT_PRECISION);
b_bins = linspace(b_lim(1), b_lim(2), 2^QUANT_PRECISION);
for n = 1:length(zeroIdx)
    
    if ~zeroIdx(n)
        b_recon(n) = b_bins(find(b(counter) == quant_range));
        counter = counter + 1;
    end
    
end

y_recon = idct(b_recon);

