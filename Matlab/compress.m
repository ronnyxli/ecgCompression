
function [b0, b_quant, b_limits, zeroIdx] = compress(y, params)

ENERGY_THRESH = params.ENERGY_THRESH;
QUANT_PRECISION = params.QUANT_PRECISION; % bits

% % manual DCT
% N = length(y);
% X = zeros(1,N);
% for k = 1:N    
%     % compute summation
%     Xk = 0;    
%     for n = 1:N
%         d = y(n)*cos( (pi/N)*(n-1+(1/2))*(k-1) );
%         Xk = Xk + d;
%     end    
%     X(k) = Xk;    
% end
% % TODO: scaling

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
[b_quant, b_limits] = quantize(b, QUANT_PRECISION);

% TODO: encoding




