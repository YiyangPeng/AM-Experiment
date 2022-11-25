clc;clear;
array = [-2,0,0; -1,0,0; 0,0,0; 1,0,0; 2,0,0]; %Set up 5 sensors
directions = [30,0; 35,0; 90,0];%Set up azimuth angles for 3 sources
S = spv(array,directions);%5×3 manifold matrix, Si,j means the gain for the jth sources in ith receiver
Rmm = [1,0,0; 0,1,0; 0,0,1]; %Covariance matrix for 3 source
sigma2 = 0.0001;
Rxx_theoretical = S*Rmm*S'+sigma2*eye(5,5);
L=250; % Generate 250 snapshots
x=1/sqrt(2)*(randn(length(array),L)+ 1i*randn(length(array),L)); % Form Gaussian random complex vector
[E,D]=eig(Rxx_theoretical); % Eigendecomposition of Rxx
xx=E*sqrt(D)*x;% Form received signal of 250 snapshots
Rxx1=xx*xx'/length(xx); % Calculated practical covariance matrix
M1 = AIC(Rxx1,length(array),length(x));
M2 = MDL(Rxx1,length(array),length(x));

%% Detection
load Xaudio.mat;
Rxx_au = X_au*X_au'/length(X_au);
M3 = AIC(Rxx_au,length(array),length(X_au));

load Ximage.mat;
Rxx_im = X_im*X_im'/length(X_im);
M4 = AIC(Rxx_im,length(array),length(X_im));
