
function [b0, b_quant, b_limits, zeroIdx] = compress(y, params)

ENERGY_THRESH = params.ENERGY_THRESH;
QUANT_PRECISION = params.QUANT_PRECISION; % bits

% DCT coefficients
b = dct(y);
b0 = b;

% use ENERGY_THRESH to determine COEFF_THRESH
[b_desc,idx] = sort(abs(b),'descend');
b_cs = cumsum(b_desc);
threshIdx = find(b_cs < b_cs(end)*ENERGY_THRESH,1,'last');
COEFF_THRESH = b_desc(threshIdx);

% save index of all coefficients < COEFF_THRESH
zeroIdx = abs(b) < COEFF_THRESH;

% remove all coefficients < COEFF_THRESH
b(zeroIdx) = [];

% quantize remaining coefficients
b_quant = zeros(1,length(b));
h = histogram(b, 2^QUANT_PRECISION);
quant_range = linspace(-2^(QUANT_PRECISION-1),2^(QUANT_PRECISION-1)-1,2^QUANT_PRECISION);
for n = 2:length(h.BinEdges)    
    lo = h.BinEdges(n-1);
    hi = h.BinEdges(n);    
    idx = find(b >= lo & b < hi);    
    b_quant(idx) = quant_range(n-1);    
end
b_quant = int8(b_quant);
b_limits = h.BinLimits;


