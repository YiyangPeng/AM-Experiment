clc;clear;

array = [-2,0,0; -1,0,0; 0,0,0; 1,0,0; 2,0,0]; %Set up 5 sensors
directions = [30,0; 35,0; 90,0];%Set up azimuth angles for 3 sources
M= 3; %Number of sources

Z = pattern1(array);
plot2d3d(Z,[0:180],0,'gain in dB','inital pattern');
Z_sources = [Z(30),Z(35),Z(90)]; %Gains from three sources

S = spv(array,directions);%5×3 manifold matrix, Si,j means the gain for the jth sources in ith receiver
Rmm = [1,0,0; 0,1,0; 0,0,1]; %Covariance matrix for 3 source
sigma2 = 0.0001;
Rxx_theoretical = S*Rmm*S'+sigma2*eye(5,5);
[~,D,~] = svd(Rxx_theoretical); % svd of Rxx_theoretical
[U1,gama1,V1] = eig(Rxx_theoretical); % svd of Rxx_theoretical 

load Xaudio.mat;
load Ximage.mat;
soundsc(real(X_au(2,:)), 11025); % audio received at 2nd antenna
displayimage(X_im(2,:),image_size, 201,'The received signal at the 2nd antenna'); %image received at 2nd antenna
    
%% detection problem
Rxx_au = X_au *X_au'/length(X_au);
Rxx_im = X_im *X_im'/length(X_im);
directions=[];
Rmm=[];
S=[];
sigma2=[];

D_au = svd(Rxx_au);
D_im = svd(Rxx_im);

%% estimation problem (Noise power 0.0001)
Sd=spv(array,[90,0]);
directions = [30,0; 35,0; 90,0];
S = spv(array,directions);
Rmm = [1,0,0; 0,1,0; 0,0,1];
sigma2 = 0.0001;
Rxx_theoretical = S*Rmm*S'+sigma2*eye(5,5);
wopt=1*inv(Rxx_theoretical)*Sd;
Z=pattern1(array, wopt);
plot2d3d(Z,[0:180],0,'gain in dB','W-H array pattern');

%% estimation problem (Noise power 0.1)
Sd=spv(array,[90,0]);
directions = [30,0; 35,0; 90,0];
S = spv(array,directions);
Rmm = [1,0,0; 0,1,0; 0,0,1];
sigma2 = 0.1;
Rxx_theoretical = S*Rmm*S'+sigma2*eye(5,5);
wopt=1*inv(Rxx_theoretical)*Sd;
Z=pattern1(array, wopt);
plot2d3d(Z,[0:180],0,'gain in dB','W-H array pattern');

%% MUSIC Rxx_theoretical
Z = music1(array, Rxx_theoretical, M);
plot2d3d(Z,[0:180],0,'dB','Music spectrum theoretical');

%% MUSIC Rxx_au
Z = music1(array, Rxx_au, M);
plot2d3d(Z,[0:180],0,'dB','Music spectrum audio');

%% MUSIC Rxx_im
Z = music1(array, Rxx_im, M);
plot2d3d(Z,[0:180],0,'dB','Music spectrum image');

%% Reception audio
Sd=spv(array,[90,0]);
wopt=1*inv(Rxx_au)*Sd;   
yt=wopt'*X_au;
soundsc(real(yt), 11025);

%% Reception image
Sd=spv(array,[90,0]);
wopt=8000*inv(Rxx_im) *Sd;
yt=wopt'*X_im;
displayimage(yt, image_size, 202,'The received signal at o/p of W-H beamformer');

%% Superresolution Beamformer
directions = [30,0; 35,0; 90,0];
S = spv(array,directions);
directionsJ = [30,0; 35,0]; % Directions of jammer
SJ = spv(array,directionsJ);
directionsD = [90,0]; % Desired direction
SD = spv(array,directionsD);
%P_SJ=SJ*inv(SJ'*SJ)*SJ';
%P_SJ_comp = eye(5)- P_SJ;
%w = P_SJ_comp*SD;
OP=fpoc(SJ); % Calculate the complement projection of desired manifold vector onto SJ
w=0.25*OP*SD; % Obtain the weight of beamformer
yt = w'*X_im;
displayimage(yt, image_size, 203,'The received signal at o/p of Superresolution beamformer');
Z1 = pattern1(array,w);
%soundsc(real(yt), 11025);   
plot2d3d(Z1,[0:180],0,'gain in dB','Array pattern in superresolution beamformer');  

