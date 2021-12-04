%close all, clear all, clc

% lambda = 1800 pps and f = 1.000.000 Bytes. N=50, P = 10000,
% 90% confidence intervals and C = 10, 20, 30 and 40 Mbps. 

fprintf('Task 1 - Alinea D\n');
lambda = 1800;
Carray = [10*10^6, 20*10^6, 30*10^6, 40*10^6];
f = 1000000;
N = 50;  

packetSize = 64:1518;
%delay = 10*10^-6;

prob = zeros(1,1518);
prob(packetSize) = (1 - 0.19 - 0.23 -0.17) / (length(packetSize)-3);
prob(64) = 0.19;
prob(110) = 0.23;
prob(1518) = 0.17;

for index=1:numel(Carray)
     
    Spacket = packetSize.*8./Carray(index);
    Spacket2= Spacket.^2;
    E = sum(prob(packetSize).*Spacket);
    E_2 = sum(prob(packetSize).*Spacket2);
    avgPacketSize = sum(prob(packetSize).*packetSize);

    AvPacketDelay = (((lambda.*E_2) ./ (2*(1-lambda.*E)))+E)*10^3; %converter em ms

    fprintf('o valor de C: %.2e \n',Carray(index));
    fprintf('AvPacketDelay= %.2e \n',AvPacketDelay);

end
 
% conclusao : quanto maior C menor o tempo medio de espera 
