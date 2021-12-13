%close all, clear all, clc

% 2.f -> novo simulador 4 (Simulator4_f)
% lambda = 1500 pps, C = 10 Mbps and f = 10.000 Bytes. Run new Simulator4
% 50 times with a stopping criterion of P = 10000 each run and compute the
% estimated values and the 90% confidence intervals of the average delay 
% and packet loss performance parameters of data packets and VoIP packets
% when n = 10, 20, 30 and 40 VoIP flows.
% Present the results of each of the 4 performance parameters 
% (average data packet delay, average VoIP packet delay, data packet loss 
% and VoIP packet loss) in different figures (in all cases, in bar charts 
% with the confidence intervals in error bars)

fprintf('Task 2 - Alinea F\n');

P = 10000;
lambda = 1500;
C = 10;
f = 10000;
n = [10,20,30,40];

for index=1:numel(n)

    N = 50;
    alfa=0.1; % 90% confidence intervals
    PL_lst_data = zeros(1,N);
    APD_lst_data = zeros(1,N);
    MPD_lst_data = zeros(1,N);
   
    PL_lst_VoIP = zeros(1,N);
    APD_lst_VoIP = zeros(1,N);
    MPD_lst_VoIP = zeros(1,N);
    
    TT_lst = zeros(1,N);

    for i = 1:N
        [PL_lst_data(i),PL_lst_VoIP(i),APD_lst_data(i),APD_lst_VoIP(i),MPD_lst_data(i),MPD_lst_VoIP(i),TT_lst(i)] = Simulator4_f(lambda,C,f,P,n(index));
    end    
    fprintf('Valor %d de n for VoIP:\n',n(index));
    
    % Calculate Data Packet Loss
    PL_data = mean(PL_lst_data);
    PL_conf_data = norminv(1-alfa/2)*sqrt(var(PL_lst_data)/N);
    fprintf('PacketLoss_Data (%%) = %.2e +- %.2e\n',PL_data,PL_conf_data)
    
    % Calculate VoIP Packet Loss
    PL_VoIP = mean(PL_lst_VoIP);
    PL_conf_VoIP = norminv(1-alfa/2)*sqrt(var(PL_lst_VoIP)/N);
    fprintf('PacketLoss_VoIP (%%) = %.2e +- %.2e\n',PL_VoIP,PL_conf_VoIP)

    % Calculate Average Data Packet Delay 
    APD_data = mean(APD_lst_data);
    APD_conf_data = norminv(1-alfa/2)*sqrt(var(APD_lst_data)/N);
    fprintf('Data Av. Packet Delay (ms)= %.2e +-%.2e\n',APD_data,APD_conf_data);
    
    % Calculate Average VoIP Packet Delay   
    APD_VoIP = mean(APD_lst_VoIP);
    APD_conf_VoIP = norminv(1-alfa/2)*sqrt(var(APD_lst_VoIP)/N);
    fprintf('VoIP Av. Packet Delay (ms)= %.2e +-%.2e\n',APD_VoIP,APD_conf_VoIP);

    PL_Results_data(index) = PL_data;
    PL_Erro_data(index) = PL_conf_data;

    PL_Results_VoIP(index) = PL_VoIP;
    PL_Erro_VoIP(index) = PL_conf_VoIP;

    APD_Results_data(index) = APD_data;
    APD_Erro_data(index) = APD_conf_data;

    APD_Results_VoIP(index) = APD_VoIP;
    APD_Erro_VoIP(index) = APD_conf_VoIP;

end

% figure for Calculate Data Packet Loss
figure(1);
bar(n,PL_Results_data);
title("Data Packet Loss (%) - Alinea F");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 2])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,PL_Results_data,PL_Erro_data,PL_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Calculate VoIP Packet Loss
figure(2);
bar(n,PL_Results_VoIP);
title("VoIP Packet Loss (%) - Alinea F");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 2])
ylabel("VoIP Paket Delay");
hold on
er1 = errorbar(n,PL_Results_VoIP,PL_Erro_VoIP,PL_Erro_VoIP);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average Data Packet Delay 
figure(3);
bar(n,APD_Results_data);
title("Data Av. Packet Delay (ms) - Alinea F");
grid on 
xlabel("Number of VoIP packets flows");
ylim([0 4])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,APD_Results_data,APD_Erro_data,APD_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average VoIP Packet Delay  
figure(4);
bar(n,APD_Results_VoIP);
title("VoIP Av. Packet Delay (ms) - Alinea F");
grid on 
xlabel("Number of VoIP packets flows");
ylim([0 4])
ylabel("VoIP Paket Delay");
hold on
er2 = errorbar(n,APD_Results_VoIP,APD_Erro_VoIP,APD_Erro_VoIP);    
er2.Color = [0 0 0];
er2.LineStyle = 'none';
hold off