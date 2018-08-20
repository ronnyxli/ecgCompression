
clear all; close all;

% load sample file
load('mitdb_100.mat');

out = compress_ecg(t, signal(:,1), Fs);

% TODO: calculate RMSE

