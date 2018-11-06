
clear all; close all;

% load sample files
dataDir = 'testData';
fileList = dir(dataDir);

% compression parameters
params.ENERGY_THRESH = 0.9; 
params.QUANT_PRECISION = 8; % bits

if length(fileList) > 2
    
    fileList(1:2) = [];
    
    % loop all test files
    for n = 1:length(fileList)
        
        load([dataDir '/' fileList(n).name]);
        sig = signal(:,1)';
        
        % z-score transformation on signal of interest
        sig = (sig - mean(sig))/std(sig);

        [B0, B_QUANT, B_RANGE, ZERO] = compress(sig, params);
        
        % calculate compression ratio
        num_bytes_original = length(sig)*8; % 8 bytes per double        
        num_bytes_compressed = length(B_QUANT)*(params.QUANT_PRECISION/8) + (length(ZERO)/8) + (length(B_RANGE)*8);
        CR = num_bytes_original/num_bytes_compressed;
        
        [Y,B_RECON] = decompress(B_QUANT, B_RANGE, ZERO, params);

        % calculate RMSE
        y = sig;
        MSE = sum( (y - Y).^2 );
        RMSE = sqrt(MSE);
        
        % calculate PRD
        PRD = sqrt(MSE/sum(y.^2));
        
        % plot results
        figure; subplot(2,1,1);
        plot(B0);
        hold on; plot(B_RECON);
        title('DCT Coefficients');
        legend('Original','Reconstructed');
        
        subplot(2,1,2);
        plot(y); 
        hold on; plot(Y);
        xlabel('Sample #');
        title(sprintf('ECG signal (Compression ratio = %0.2f:1, PRD = %0.2f)', CR, PRD));
        legend('Original','Reconstructed');
        
    end
    
end

