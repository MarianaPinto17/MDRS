%% task 2 -> use simulator 3 and 4

%% 2.a -> simulator 3
fprintf('Alinea A\n');

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
        [PL_lst_data(i),PL_lst_VoIP(i),APD_lst_data(i),APD_lst_VoIP(i),MPD_lst_data(i),MPD_lst_VoIP(i),TT_lst(i)] = Simulator3(lambda,C,f,P,n(index));
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
title("Data Av. Packet Delay (ms) - Alinea A");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 7])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,APD_Results_data,APD_Erro_data,APD_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average VoIP Packet Delay  
figure(2);
bar(n,APD_Results_VoIP);
grid on
title("VoIP Av. Packet Delay (ms) - Alinea A");
xlabel("Number of VoIP packets flows");
ylim([0 7])
ylabel("VoIP Paket Delay");
hold on
er2 = errorbar(n,APD_Results_VoIP,APD_Erro_VoIP,APD_Erro_VoIP);    
er2.Color = [0 0 0];
er2.LineStyle = 'none';
hold off


%% 2.b -> simulador 4

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
figure(3);
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
figure(4);
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


%% 2.c -> valor teorico
%ver o 5.e

%% 2.d -> silumador 3

fprintf('Alinea D\n');

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
        [PL_lst_data(i),PL_lst_VoIP(i),APD_lst_data(i),APD_lst_VoIP(i),MPD_lst_data(i),MPD_lst_VoIP(i),TT_lst(i)] = Simulator3(lambda,C,f,P,n(index));
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
figure(5);
bar(n,PL_Results_data);
title("Data Packet Loss (%) - Alinea D");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 1.6])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,PL_Results_data,PL_Erro_data,PL_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Calculate VoIP Packet Loss
figure(6);
bar(n,PL_Results_VoIP);
title("VoIP Packet Loss (%) - Alinea D");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 1.6])
ylabel("VoIP Paket Delay");
hold on
er1 = errorbar(n,PL_Results_VoIP,PL_Erro_VoIP,PL_Erro_VoIP);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average Data Packet Delay 
figure(7);
bar(n,APD_Results_data);
title("Data Av. Packet Delay (ms) - Alinea D");
grid on 
xlabel("Number of VoIP packets flows");
ylim([0 3.5])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,APD_Results_data,APD_Erro_data,APD_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average VoIP Packet Delay  
figure(8);
bar(n,APD_Results_VoIP);
title("VoIP Av. Packet Delay (ms) - Alinea D");
grid on 
xlabel("Number of VoIP packets flows");
ylim([0 3.5])
ylabel("VoIP Paket Delay");
hold on
er2 = errorbar(n,APD_Results_VoIP,APD_Erro_VoIP,APD_Erro_VoIP);    
er2.Color = [0 0 0];
er2.LineStyle = 'none';
hold off

%% 2.e -> simulador 4

fprintf('Alinea E\n');

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
        [PL_lst_data(i),PL_lst_VoIP(i),APD_lst_data(i),APD_lst_VoIP(i),MPD_lst_data(i),MPD_lst_VoIP(i),TT_lst(i)] = Simulator4(lambda,C,f,P,n(index));
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
figure(9);
bar(n,PL_Results_data);
title("Data Packet Loss (%) - Alinea D");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 1.7])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,PL_Results_data,PL_Erro_data,PL_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Calculate VoIP Packet Loss
figure(10);
bar(n,PL_Results_VoIP);
title("VoIP Packet Loss (%) - Alinea D");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 1.7])
ylabel("VoIP Paket Delay");
hold on
er1 = errorbar(n,PL_Results_VoIP,PL_Erro_VoIP,PL_Erro_VoIP);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average Data Packet Delay 
figure(11);
bar(n,APD_Results_data);
title("Data Av. Packet Delay (ms) - Alinea D");
grid on 
xlabel("Number of VoIP packets flows");
ylim([0 4.3])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,APD_Results_data,APD_Erro_data,APD_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average VoIP Packet Delay  
figure(12);
bar(n,APD_Results_VoIP);
title("VoIP Av. Packet Delay (ms) - Alinea D");
grid on 
xlabel("Number of VoIP packets flows");
ylim([0 4.3])
ylabel("VoIP Paket Delay");
hold on
er2 = errorbar(n,APD_Results_VoIP,APD_Erro_VoIP,APD_Erro_VoIP);    
er2.Color = [0 0 0];
er2.LineStyle = 'none';
hold off

%% 2.f -> novo simulador 4 (Simulator4_f)

fprintf('Alinea F\n');

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
figure(13);
bar(n,PL_Results_data);
title("Data Packet Loss (%) - Alinea D");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 1.7])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,PL_Results_data,PL_Erro_data,PL_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Calculate VoIP Packet Loss
figure(14);
bar(n,PL_Results_VoIP);
title("VoIP Packet Loss (%) - Alinea D");
grid on
xlabel("Number of VoIP packets flows");
ylim([0 1.7])
ylabel("VoIP Paket Delay");
hold on
er1 = errorbar(n,PL_Results_VoIP,PL_Erro_VoIP,PL_Erro_VoIP);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average Data Packet Delay 
figure(15);
bar(n,APD_Results_data);
title("Data Av. Packet Delay (ms) - Alinea D");
grid on 
xlabel("Number of VoIP packets flows");
ylim([0 4.3])
ylabel("Data Paket Delay");
hold on
er1 = errorbar(n,APD_Results_data,APD_Erro_data,APD_Erro_data);    
er1.Color = [0 0 0];                            
er1.LineStyle = 'none';
hold off

% figure for Average VoIP Packet Delay  
figure(16);
bar(n,APD_Results_VoIP);
title("VoIP Av. Packet Delay (ms) - Alinea D");
grid on 
xlabel("Number of VoIP packets flows");
ylim([0 4.3])
ylabel("VoIP Paket Delay");
hold on
er2 = errorbar(n,APD_Results_VoIP,APD_Erro_VoIP,APD_Erro_VoIP);    
er2.Color = [0 0 0];
er2.LineStyle = 'none';
hold off