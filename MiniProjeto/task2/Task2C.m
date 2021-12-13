%close all, clear all, clc

% Consider that the system is modelled by a M/G/1 queueing model with 
% priorities. Determine the theoretical values of the average data 
% packet delay and average VoIP packet delay using the M/G/1 model for
% all cases of 2.b.

%wa = pacotes voip
%wb e para os data

fprintf('Task 2 - Alinea C\n');

P = 10000; %number of packets
lambda = 1500; %pacotes data
N=10;

C = 10*10^6;
%packetSize = 64;
packetSize = 64:1518;
%delay = 10*10^-6;

prob = zeros(1,1518);
prob(packetSize) = (1 - 0.19 - 0.23 -0.17) / (length(packetSize)-3);
prob(64) = 0.19;
prob(110) = 0.23;
prob(1518) = 0.17;

f = 1000000;
n = [10,20,30,40]; %lambda para os pacotes de VoIP
%igual para os dois
%u = C/(packetSize*8);
%u_2 = u^2;
Spacket = packetSize.*8./C;
Spacket2= Spacket.^2;
E = sum(prob(packetSize).*Spacket);
E_2 = sum(prob(packetSize).*Spacket2);
avgPacketSize = sum(prob(packetSize).*packetSize);

p_data = lambda*E;
p_VoIP = N*E;

%w_data =(((lambda*E_2 + 750*E_2) /(2*(1-p_data)) ) + E)*10^3
%wa =(((lambda*E_2+N*E_2) /(2*(1-p_data)) )+ E) * 10^3 % valor em ms
%wb = (((lambda*E_2+N*E_2) / ((2*(1-p_data))* (1-p_data-p_VoIP))) + E) * 10^3


for index=1:numel(n) %danos o lambda dos pacotes VoIP

    p_VoIP = n(index)*E;
    w_Voip =(((n(index)*E_2+lambda*E_2) /(2*(1-p_VoIP)) )+ E) * 10^3; % valor em ms
    w_data = (((n(index)*E_2+lambda*E_2) / (2*(1-p_VoIP)*(1-p_VoIP-p_data)) ) +E) * 10^3;
    fprintf('o valor de n: %.2e \n',n(index));
    fprintf('AvDataPacketDelay= %.2e \n',w_data);
    fprintf('AvVoIPPacketDelay= %.2e \n',w_Voip);
    fprintf('\n');
end
