function Z=music1(array, Rxx, numofsources)
[eigenVec,eigenVal] = eig(Rxx); % Eigen-decomposition of Rxx
Val = diag(eigenVal)'; % Get eigenvalues 
[Val,I] = sort(Val); % Sort eigenvalues from smallest to largest
Vec = fliplr(eigenVec(:,I)); % Sort eigenvectors accoring to eigenvalues from largest to smallest
N = 5; % Number of sensors
for azimuth = 0:180 % For any azimuth angle to find minimum cost function
    En = Vec(:,numofsources+1:N); % Obtain eigenvectors of noise subspace
    S = spv(array,[azimuth,0]); % Calculate manifold vectors
    cost = S'*En*En'*S; % Calculate cost function
    cost_music(azimuth+1)=1/cost; % Find maximaum points, which correspond to the direction of source
end
Z=abs(cost_music);
Z=10*log10(Z);

