function Rmm_smooth = smooth(Numofsource, Rmm, S)
p = 3; %Number of subarray
M = 5; %Number of sensors
N = M-p+1; %Number of array elements in each subarray
D=zeros(Numofsource); % Initialise matrix D
for i=1:Numofsource % Put response of first sensor into D
    D(i,i)=S(1,i);
end
Rmm_smooth = zeros(3);
for k=1:p % For each subarray
    Rmm_smooth=Rmm_smooth+D^(k-1)*Rmm*(D^(k-1))'; % Calculate sum of Rmm_smooth
end
Rmm_smooth = Rmm_smooth*1/N; % Find mean of Rmm_smooth


