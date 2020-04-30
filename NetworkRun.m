%%Function - Returns The activity of E/I populations

%Input:
%Number of Patterns to store
%Strenghts of inhibitory plasticity (0 for no inhibitory learning)
%Strenght of stimulus given as the % stimulated nodes during retrieval

function [E, I] = NetworkRun(Num_Patterns, pl, st)
NetSize = 100; %Network size
dt = 0.1; %ms
int = 10;

%Model Parameters
tau_e = 5;
tau_i = 5;
beta_e = 1.3;
theta_e= 4;
beta_i= 2;
theta_i= 3.7;

%Initial Internal weights
w_ee = 18;
w_ei = 14;
w_ie = 12;
w_ii = 4;


%Simulation times setting
Pattern_learning_time = 100*Num_Patterns; %ms
Inhibitory_learning_time = 400; %ms
Retrieval_phase_time = 1600; %ms

duration = Pattern_learning_time +Inhibitory_learning_time + Retrieval_phase_time;


%% Initialize 

timesteps = duration/dt;

%Population Activity
E = zeros(NetSize,timesteps); %Excitatory activity in each node
I = zeros(NetSize,timesteps); %Inhibitory activity in each node

%Save activity 
E_temp = zeros(NetSize,1);
I_temp = zeros(NetSize,1);

%Internal Inhibitory to Excitatory Connections
W_i = w_ie*ones(NetSize,timesteps); 

%Inter-Node connections
We = zeros(NetSize,NetSize);
Wi = zeros(NetSize,NetSize);
W = zeros(NetSize,NetSize);

%Plasticity constants
learning_rate = 0.023;
rho_0 = 0.2466;
rho_1 = 0.1;

load('PatternsToLearn', 'Memories')
memories = Memories(:,1:Num_Patterns);

%Which nodes to stimulate during retrieval
Stimulated = zeros(NetSize,1);
for s = 1:100*st
    Stimulated(s) = 1;
end
 

%% Simulation Run
for t = 2:timesteps-1
    for i = 1:NetSize
        
        %Determine stimulus
        if t < Pattern_learning_time/dt
            IN = 1 + int*memories(i,ceil(t/1000));
        elseif t > (duration -  Retrieval_phase_time + 100)/dt && t < (duration -  Retrieval_phase_time + 200)/dt
            IN = 1 + int*(i <= 100*st)*memories(i,2);
        elseif t > (duration - 100)/dt 
            IN = 1 + int*(i <= 100*st)*memories(i,1);
        else
            IN = 1.3 + 0.2*rand;
        end 

        %Update equations
        E_input = w_ee*E(i,t) - W_i(i,t)*I(i,t) +  IN + sum(sum(We(:,i).*E(:,t))) - sum(sum(Wi(:,i).*I(:,t)));
        I_input = w_ei*E(i,t) - w_ii*I(i,t) + 1 ;

        E_temp(i) =  E(i,t) + dt*(-E(i,t) + (1-E(i,t))*sigmoid(E_input,beta_e,theta_e))/tau_e;
        I_temp(i) =  I(i,t) + dt*(-I(i,t) + (1-I(i,t))*sigmoid(I_input,beta_i,theta_i))/tau_i;
        
        %Inhibitory Learning
        if (t > Pattern_learning_time/dt)&&(t < (Pattern_learning_time + Inhibitory_learning_time)/dt)
            W_i(i,t+1) =  between(0,W_i(i,t) + pl*dt*(E(i,t) - rho_1)*I(i,t),40);
        else
            W_i(i,t+1) = W_i(i,t);
        end
    end
      %% Update external weights
         if t < Pattern_learning_time/dt
             
            %Calculate Change
            W_pre = sum(sum(W));
            for k =1:NetSize
                for m =1:NetSize
                    Dw = learning_rate*(E(k,t)- rho_0)*(E(m,t)- rho_0)/Num_Patterns;
                    W(k,m) = W(k,m) + Dw;
                end
            end

            %Normalise
            W_post = sum(sum(W));
            dSum = (W_post - W_pre)/(NetSize^2);
            if W_post >= 100
               W = W - dSum;
            end

            %Set I/E weights
             for k =1:NetSize
                for m =1:NetSize
                if W(k,m)>=0
                        We(k,m) = W(k,m);
                 else
                        Wi(k,m) = -W(k,m);
                 end
                end
             end
         end
         
  %% Save step
    E(:,t+1) = E_temp;
    I(:,t+1) = I_temp;
                 
end

%% Useful Functions
%Sigmoid Non-Linearity for the W-C oscillator
    function y = sigmoid(x,beta,theta)
        y = 1/(1+exp(-beta*(x-theta))) - 1/(1+exp(beta*theta)); 
    end

% Useful Function
    function y = between(a,x,b)
        y = min(b,max(a,x));
    end

end