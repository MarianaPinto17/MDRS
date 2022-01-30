clear all;
close all;

fprintf('Task 2 - Alinea A\n');
Nodes= [30 70
       350 40
       550 180
       310 130
       100 170
       540 290
       120 240
       400 310
       220 370
       550 380];
   
Links= [1 2
        1 5
        2 3
        2 4
        3 4
        3 6
        3 8
        4 5
        4 8
        5 7
        6 8
        6 10
        7 8
        7 9
        8 9
        9 10];

T= [1  3  1.0 1.0
    1  4  0.7 0.5
    2  7  2.4 1.5
    3  4  2.4 2.1
    4  9  1.0 2.2
    5  6  1.2 1.5
    5  8  2.1 2.5
    5  9  1.6 1.9
    6 10  1.4 1.6];

nNodes= 10;

nLinks= size(Links,1);
nFlows= size(T,1);

B= 625;  %Average packet size in Bytes

co= Nodes(:,1)+j*Nodes(:,2);

L= inf(nNodes);    %Square matrix with arc lengths (in Km)
for i=1:nNodes
    L(i,i)= 0;
end
C= zeros(nNodes);  %Square matrix with arc capacities (in Gbps)
for i=1:nLinks
    C(Links(i,1),Links(i,2))= 10;  %Gbps
    C(Links(i,2),Links(i,1))= 10;  %Gbps
    d= abs(co(Links(i,1))-co(Links(i,2)));
    L(Links(i,1),Links(i,2))= d+5; %Km
    L(Links(i,2),Links(i,1))= d+5; %Km
end
L= round(L);  %Km

% Compute up to 100 paths for each flow:
n= 100;
[sP nSP]= calculatePaths(L,T,n);

%Compute the link loads using the first (shortest) path of each flow:
%sol= ones(1,nFlows);
%Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
%maxLoad= max(max(Loads(:,3:4)));

fprintf('\nSolution random with all possible routing paths\n');
t= tic;
bestEnergy= inf;
sol= zeros(1,nFlows);
allValues= [];
%quando mais comprimento do link mais energia -> logo queremos o que tem
%menos energia, menos comprimento
while toc(t)<10
    for i= 1:nFlows
        sol(i)= randi(nSP(i));
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<=10
        energy = 0;
        for a=1:nLinks
            %loads(a,1) loads(a,2) sao os nós
            %loads(a,3) loads(a,4) sao os valores dos trafegos (cargas) que
            %passam no link entre os nós, nas duas direcoes
            % ve se esta a passar trafego entre os links numa e noutra direcao
            if Loads(a,3)+Loads(a,4)>0 %esta a suportar trafego nao pode dormir
                energy = energy + L(Loads(a,1),Loads(a,2)); %a energia e igual a energia + o comprimento do link (L -> comprimento do link)
            end
        end
    else
        energy=inf; %garante que nao escolhe se a capacidade/carga for maior que 10 gigabits
    end
    %vai escolher a menor energia
    allValues= [allValues energy];
    if energy<bestEnergy
        bestSol= sol;
        bestEnergy= energy;
    end
    %problema -> poupa energia consentrando ao maximo o numero de percursos
    %pelos menores links mas nao queremos uma solucao com a carga maxima de
    %10 gigabits por segundo, para verificar isso precisamos do if do
    %load<=10
end
figure(1)
grid on
plot(sort(allValues));
title('Random Algorithm - Task 2.A')
fprintf('Energy consumption value of the best solution = %.1f \n', bestEnergy);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.1f \n', mean(allValues));


fprintf('\nSolution random with 10 shortest routing paths\n');
t= tic;
bestEnergy= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    for i= 1:nFlows
        n = min(10,nSP(i)); %correr so 10 vezes -> os primeiros 10
        sol(i)= randi(n);
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<=10
        energy = 0;
        for a=1:nLinks
            if Loads(a,3)+Loads(a,4)>0 %esta a suportar trafego nao pode dormir
                energy = energy + L(Loads(a,1),Loads(a,2)); %a energia e igual a energia + o comprimento do link (L -> comprimento do link)
            end
        end
    else
        energy=inf; %garante que nao escolhe se a capacidade/carga for maior que 10 gigabits
    end
    allValues= [allValues energy];
    if energy<bestEnergy
        bestSol= sol;
        bestEnergy= energy;
    end
    %problema -> poupa energia consentrando ao maximo o numero de percursos
    %pelos menores links mas nao queremos uma solucao com a carga maxima de
    %10 gigabits por segundo, para verificar isso precisamos do if do
    %load<=10
end

hold on
grid on
plot(sort(allValues));
fprintf('Energy consumption value of the best solution = %.1f \n', bestEnergy);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.1f \n', mean(allValues));


fprintf('\nSolution random with 5 shortest routing paths\n');
t= tic;
bestEnergy= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    for i= 1:nFlows
        n = min(5,nSP(i)); %correr so 5 vezes -> os primeiros 5
        sol(i)= randi(n);
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<=10
        energy = 0;
        for a=1:nLinks
            if Loads(a,3)+Loads(a,4)>0 %esta a suportar trafego nao pode dormir
                energy = energy + L(Loads(a,1),Loads(a,2)); %a energia e igual a energia + o comprimento do link (L -> comprimento do link)
            end
        end
    else
        energy=inf; %garante que nao escolhe se a capacidade/carga for maior que 10 gigabits
    end
    allValues= [allValues energy];
    if energy<bestEnergy
        bestSol= sol;
        bestEnergy= energy;
    end
    %problema -> poupa energia consentrando ao maximo o numero de percursos
    %pelos menores links mas nao queremos uma solucao com a carga maxima de
    %10 gigabits por segundo, para verificar isso precisamos do if do
    %load<=10
end

hold on
grid on
plot(sort(allValues));
legend('Random with all possible','Random with 10 shortest','Random with 5 shortest',Location="southeast");
fprintf('Energy consumption value of the best solution = %.1f \n', bestEnergy);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.1f \n', mean(allValues));
