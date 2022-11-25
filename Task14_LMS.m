clc;clear;
load Ximage.mat;
array=[-2 0 0; -1 0 0; 0 0 0; 1 0 0; 2 0 0]; %Set up 5 sensors
N = 5;  %Number of sensors
L = length(X_im);  %Number of snapshots
directions=[30,0;35,0;90,0]; %Set up azimuth angles for 3 sources
directionsJ=[35,0;90,0];% Directions of interferences
SJ=spv(array,directionsJ); % Manifold vectors of interferences
directionD=[30,0]; % Direction of desired signal
SD=spv(array,directionD); % Manifold vector of desired signal
OP=fpoc(SJ); % Calculate the complement projection of desired manifold vector onto SJ
w=OP*SD; % Calculate the weight of beamformer
y_d=w'*X_im; % Obtain desired signal
w_lms = zeros(N,1);  %Initalise weight

% Calculate the bound of mu
Rxx_im = X_im *X_im'/length(X_im);
lambda = max(eig(Rxx_im)); % Find maximum eigenvalue
mu_max = 1/lambda;
mu = 1*10^-6;   % convergence factor

% Run LMS algorithm
for i = 1:L
    y(i) = w_lms'* X_im(:,i); % Update weights with image signal
    e(i) = y_d(i) - y(i); % Calculate error
    w_lms = w_lms + mu * e(i)'*X_im(:,i); % Update weights
end
Z = pattern1(array,w_lms);
plot2d3d(Z,[0:180],0,'gain in dB','Array pattern in LMS adaptive beamformer with 30 degree desired source');
yt = 8 * w_lms'* X_im; % Update final weight with image and multiply constant
displayimage(yt,image_size,2,'The received signal at o/p of LMS adaptive beamformer');