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

% Initialisation for RLS algorithm
alpha = 1;
delta = 0.8;
w_rls = zeros(N,1); 
R = eye(N)/delta;
% Run RLS algorithm
for i=1:L
error = y_d(i)- w_rls'*X_im(:,i); % Calculate error signal
R = R - (R*X_im(:,i)*X_im(:,i)'*R)/(alpha+X_im(:,i)'*R*X_im(:,i)); % Calculate Hermitian matrix R
w_rls = w_rls + R*X_im(:,i)*error'; % Update weights
end
Z = pattern1(array,w_rls);
plot2d3d(Z,[0:180],0,'gain in dB','Array pattern in RLS adaptive beamformer with 30 degree desired source');
yt = 8 * w_rls'* X_im; % Update final weight with image and multiply constant
displayimage(yt,image_size,2,'The received signal at o/p of RLS adaptive beamformer');



