
function [PL , APD,APD_64,APD_110,APD_1518 , MPD , TT] = Simulator1New(lambda,C,f,P)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
% OUTPUT PARAMETERS:
%  PL   - packet loss (%)
%  APD  - average packet delay (milliseconds)
%  MPD  - maximum packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet

%State variables:
STATE = 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETS= 0;       % No. of packets arrived to the system
LOSTPACKETS= 0;        % No. of packets dropped due to buffer overflow
TRANSMITTEDPACKETS= 0; % No. of transmitted packets
TRANSMITTEDPACKETS_64= 0;   % No. of transmitted packets with 64 packetSize
TRANSMITTEDPACKETS_110= 0;  % No. of transmitted packets with 110 packetSize
TRANSMITTEDPACKETS_1518= 0; % No. of transmitted packets with 1518 packetSize
TRANSMITTEDBYTES= 0;   % Sum of the Bytes of transmitted packets
DELAYS= 0;             % Sum of the delays of transmitted packets
DELAYS_64= 0;          % Sum of the delays of transmitted packets with 64 packetSize
DELAYS_110= 0;         % Sum of the delays of transmitted packets with 110 packetSize
DELAYS_1518= 0;        % Sum of the delays of transmitted packets with 1518 packetSize
MAXDELAY= 0;           % Maximum delay among all transmitted packets

% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
EventList = [ARRIVAL, tmp, GeneratePacketSize(), tmp];

%Similation loop:
while TRANSMITTEDPACKETS<P               % Stopping criterium
    EventList= sortrows(EventList,2);    % Order EventList by time
    Event= EventList(1,1);               % Get first event and 
    Clock= EventList(1,2);               %   and
    PacketSize= EventList(1,3);          %   associated
    ArrivalInstant= EventList(1,4);      %   parameters.
    EventList(1,:)= [];                  % Eliminate first event
    switch Event
        case ARRIVAL                     % If first event is an ARRIVAL
            TOTALPACKETS= TOTALPACKETS+1;
            tmp= Clock + exprnd(1/lambda);
            EventList = [EventList; ARRIVAL, tmp, GeneratePacketSize(), tmp];
            if PacketSize==64
                if STATE==0
                    STATE= 1;
                    EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock];
                else
                    if QUEUEOCCUPATION + PacketSize <= f
                        QUEUE= [QUEUE;PacketSize , Clock];
                        QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                    else
                        LOSTPACKETS= LOSTPACKETS + 1;
                    end
                end
            elseif PacketSize==110
                if STATE==0
                    STATE= 1;
                    EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock];
                else
                    if QUEUEOCCUPATION + PacketSize <= f
                        QUEUE= [QUEUE;PacketSize , Clock];
                        QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                    else
                        LOSTPACKETS= LOSTPACKETS + 1;
                    end
                end
            elseif PacketSize==1518
                if STATE==0
                    STATE= 1;
                    EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock];
                else
                    if QUEUEOCCUPATION + PacketSize <= f
                        QUEUE= [QUEUE;PacketSize , Clock];
                        QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                    else
                        LOSTPACKETS= LOSTPACKETS + 1;
                    end
                end
            end    
        case DEPARTURE                     % If first event is a DEPARTURE
            
            if PacketSize==64
                TRANSMITTEDPACKETS_64= TRANSMITTEDPACKETS_64 + 1;
                DELAYS_64= DELAYS_64 + (Clock - ArrivalInstant);
            elseif PacketSize==110
                TRANSMITTEDPACKETS_110= TRANSMITTEDPACKETS_110 + 1;
                DELAYS_110= DELAYS_110 + (Clock - ArrivalInstant);
            elseif PacketSize==1518
                TRANSMITTEDPACKETS_1518= TRANSMITTEDPACKETS_1518 + 1;
                DELAYS_1518= DELAYS_1518 + (Clock - ArrivalInstant);
            end

            TRANSMITTEDBYTES= TRANSMITTEDBYTES + PacketSize;
            if PacketSize==64
                DELAYS64= DELAYS + (Clock - ArrivalInstant);
                if Clock - ArrivalInstant > MAXDELAY
                    MAXDELAY= Clock - ArrivalInstant;
                end
                TRANSMITTEDPACKETS= TRANSMITTEDPACKETS + 1;
                if QUEUEOCCUPATION > 0
                    EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
                    QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                    QUEUE(1,:)= [];
                else
                    STATE= 0;
                end
            elseif PacketSize == 110

                DELAYS110= DELAYS + (Clock - ArrivalInstant);
                if Clock - ArrivalInstant > MAXDELAY
                    MAXDELAY= Clock - ArrivalInstant;
                end
                TRANSMITTEDPACKETS= TRANSMITTEDPACKETS + 1;
                if QUEUEOCCUPATION > 0
                    EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
                    QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                    QUEUE(1,:)= [];
                else
                    STATE= 0;
                end
            elseif PacketSize == 1518
                DELAYS1158= DELAYS + (Clock - ArrivalInstant);
                if Clock - ArrivalInstant > MAXDELAY
                    MAXDELAY= Clock - ArrivalInstant;
                end
                TRANSMITTEDPACKETS= TRANSMITTEDPACKETS + 1;
                if QUEUEOCCUPATION > 0
                    EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
                    QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                    QUEUE(1,:)= [];
                else
                    STATE= 0;
                end
            end
    end
end

%Performance parameters determination:
PL= 100*LOSTPACKETS/TOTALPACKETS;      % in %

APD= 1000*DELAYS/TRANSMITTEDPACKETS;   % in milliseconds
APD_64= 1000*DELAYS_64/TRANSMITTEDPACKETS_64;
APD_110= 1000*DELAYS_110/TRANSMITTEDPACKETS_110;
APD_1518= 1000*DELAYS_1518/TRANSMITTEDPACKETS_1518;

MPD= 1000*MAXDELAY;                    % in milliseconds
TT= 10^(-6)*TRANSMITTEDBYTES*8/Clock;  % in Mbps

end

function out= GeneratePacketSize()
    aux= rand();
    aux2= [65:109 111:1517];
    if aux <= 0.19
        out= 64;
    elseif aux <= 0.19 + 0.23
        out= 110;
    elseif aux <= 0.19 + 0.23 + 0.17
        out= 1518;
    else
        out = aux2(randi(length(aux2)));
    end
end
