% 2.b -> simulador 4
% lambda = 1500 pps, C = 10 Mbps and f = 1.000.000 Bytes. Run Simulator4
% 50 times with a stopping criterion of P = 10000 each run and compute the 
% estimated values and the 90% confidence intervals of the average delay 
% performance parameter of data packets and VoIP packets when 
% n = 10, 20, 30 and 40 VoIP flows.
% Present the average data packet delay results in one figure and the 
% average VoIP packet delay results in another figure (in both cases, in
% bar charts with the confidence intervals in error bars).

fprintf('Alinea B\n');

P = 10000;
lambda = 1500;
C = 10;
f = 1000000;
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
        [PL_lst_data(i),PL_lst_VoIP(i),APD_lst_data(i),APD_lst_VoIP(i),MPD_lst_data(i),MPD_lst_VoIP(i),TT_lst(i)] = Simulator4(lambda,C,f,P,n(index));
    end    
    fprintf('Valor %d de n for VoIP:\n',n(index));
    
    % Calculate Average Data Packet Delay 
    APD_data = mean(APD_lst_data);
    APD_conf_data = norminv(1-alfa/2)*sqrt(var(APD_lst_data)/N);
    fprintf('Data Av. Packet Delay (ms)= %.2e +-%.2e\n',APD_data,APD_conf_data);
    
    % Calculate Average VoIP Packet Delay   
    APD_VoIP = mean(APD_lst_VoIP);
    APD_conf_VoIP = norminv(1-alfa/2)*sqrt(var(APD_lst_VoIP)/N);
    fprintf('VoIP Av. Packet Delay (ms)= %.2e +-%.2e\n',APD_VoIP,APD_conf_VoIP);

    APD_Results_data(index) = APD_data;
    APD_Erro_data(index) = APD_conf_data;

    APD_Results_VoIP(index) = APD_VoIP;
    APD_Erro_VoIP(index) = APD_conf_VoIP;

end

% figure for Average Data Packet Delay 
figure(1);
bar(n,APD_Results_data);
title("Data Av. Packet Delay (ms) - Alinea B");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 8])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,APD_Results_data,APD_Erro_data,APD_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure Average VoIP Packet Delay  
figure(2);
bar(n,APD_Results_VoIP);
grid on
title("VoIP Av. Packet Delay (ms) - Alinea B");
xlabel("Number of VoIP packets flows");
ylim([0 8])
ylabel("VoIP Paket Delay");
hold on
er2 = errorbar(n,APD_Results_VoIP,APD_Erro_VoIP,APD_Erro_VoIP);    
er2.Color = [0 0 0];
er2.LineStyle = 'none';
hold off

