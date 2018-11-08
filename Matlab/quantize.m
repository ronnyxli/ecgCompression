
function [xq, x_limits] = quantize(x, num_bits)

% define quantization range
quant_range = linspace(-2^(num_bits-1),2^(num_bits-1)-1,2^num_bits);

% compute histogram of original data
h = histogram(x, 2^num_bits);
xlabel('Floating point coefficients');
ylabel('Count');
grid on;

xq = zeros(1,length(x));
for n = 2:length(h.BinEdges)
    lo = h.BinEdges(n-1);
    hi = h.BinEdges(n);    
    xq(x >= lo & x < hi) = quant_range(n-1);
end
xq = int8(xq);
x_limits = h.BinLimits;

hq = histogram(xq, 2^num_bits);
xlabel('Quantized coefficients');
ylabel('Count');
grid on;
