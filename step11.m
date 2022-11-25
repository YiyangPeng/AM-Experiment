clc;clear;

array = [-2,0,0; -1,0,0; 0,0,0; 1,0,0; 2,0,0]; %Set up 5 sensors
directions = [30,0; 35,0; 90,0];%Set up azimuth angles for 3 sources
M= 3; %Number of sources
Rmm = [1,1,0; 1,1,0; 0,0,1]; %Covariance matrix for 3 source (30 and 35 are coherent)   
%Rmm = [1,1,0; 1,1,0; 0,0,1];
S = spv(array,directions);%5×3 manifold matrix, Si,j means the gain for the jth sources in ith receiver

sigma2 = 0.0001;
Rxx_correlated = S*Rmm*S'+sigma2*eye(5,5);
gama = svd(Rxx_correlated); % svd of Rxx_theoretical 


%% MUSIC 
Z = music1(array, Rxx_correlated, M);
plot2d3d(Z,[0:180],0,'dB','Music spectrum of correlated sources');

%% Smoothing
Rmm_smooth = smooth(M,Rmm,S);
Rxx_correlated = S*Rmm_smooth*S'+sigma2*eye(5,5);
Z = music1(array, Rxx_correlated, M);
plot2d3d(Z,[0:180],0,'dB','Music spectrum after smoothed');
