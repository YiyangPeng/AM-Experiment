function MDL=MDL(Rxx1,N,L)
eigvalue=eig(Rxx1);
eigvalue = sort(eigvalue,'descend');
% Initialisation
LF = [];
MDL = [];
val = zeros(1,N);
for k=0:N-1
    d1 = 1; % Initial eigenvalue for multiplication
    d2 = 0; % Initial eigenvalue for summation
    % Calculate LF
    for i=k+1:N
        d1 = d1*eigvalue(i)^(1/(N-k));
        d2 = d2+eigvalue(i);
    end
    d2 = d2*(1/(N-k));
    LF(k+1) = log(d1/d2)*((N-k)*L);
    MDL(k+1) = -1*LF(k+1)+0.5*k*(2*N-k)*log(L); % Use LF to calculate MDL
end
[val,index] = min(MDL); % Find the minimum value and index of MDL(k+1)
MDL = index - 1; % Convert index from 1 to 5 -> 0 to 4
