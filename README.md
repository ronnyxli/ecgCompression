# ecgCompression

ECG compression using discrete cosine transform (DCT).

The input signal is record 100 from the Physionet MIT-BIH Arrhythmia database. The signal is a 2-minute segment of ECG sampled at 360 Hz. When loaded into MATLAB, each sample is represented by a 8-byte double. Thus, the total size of the input signal is (120 sec) * (360 samples/sec) * (8 bytes) = 345600 bytes. Prior to compression, the signal is scaled (subtract by mean, divided by standard deviation).

Configurable compression parameters:
1) ENERGY_THRESH: Fraction of the energy of the DCT coefficients used to determine a threshold value. Default = 0.90.
2) QUANT_PRECISION: Number of bits to quantize remaining DCT coefficients to. Default = 8.

##### Compression

1) Calculate DCT coefficients using MATLAB's *dct* function.
2) Determine the threshold on the DCT coefficients as the value corresponding to ENERGY_THRESH% of the cumulative sum.
3) Save index of all coefficients less than the threshold - these are the coefficients to be set to 0 during decompression.
4) Quantize the remaining coefficients by mapping the distribution to a range of signed int defined by QUANT_PRECISION. For 8-bit precision, the distribution would be mapped to 256 bins over the values [-128,127].
5) The output from the *compression* function are:
	- b0: original DCT coefficients
	- b_quant: quantized DCT coefficients with zeros removed
	- b_limits: limits of the distribution of original coefficients
	- zeroIdx: binary array where 1 represents the position of a zero

	Thus, the size of the compressed signal is defined as the total number of bytes in b_quant, b_limits, and zeroIdx.

##### Decompression

1) Map quantized coefficients (b) back to original distribution defined by QUANT_PRECISION and b_lim. The coefficients defined in zeroIdx are set to zero.
2) Reconstruct the signal using MATLAB's *idct* function.

##### Result

Percent root mean square difference (PRD) is an accuracy metric defined as the square root of the mean square error divided to the total energy ratio.

![Result] (/result.png)
