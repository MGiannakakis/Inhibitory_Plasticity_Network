
%Main Script
%Creates a plot of the E/I activity of a typical node with and without the
%inhibitory tuning stage (green in the plot)

NumberPatterns = 7;

[E_with, I_with] =  NetworkRun(NumberPatterns,5,0.3);
[E_no, I_no] =  NetworkRun(NumberPatterns,0,0.3);

stimulus_line = [0:0.01:0.6];
point_1 = 12000*ones(61,1);
point_2 = 26000*ones(61,1);

%% Make Plot

figure(1)
subplot(2,2,1)
plot([1:7000],E_with(4,1:7000),'r', [7001:11000],E_with(4,7001:11000),'g',[11001:27000],E_with(4,11001:27000),'b',point_1, stimulus_line,'y',point_2, stimulus_line,'y','LineWidth',1.5)
set(gca,'FontSize',15)
title("Excitatory Population",'FontSize', 20)
xlabel("Time (mS)",'FontSize', 15)
ylabel("Activity (Hz)",'FontSize', 15)
ylim([0,0.6]);

subplot(2,2,3)
plot([1:7000],I_with(4,1:7000),'r', [7001:11000],I_with(4,7001:11000),'g',[11001:27000],I_with(4,11001:27000),'b',point_1, stimulus_line,'y',point_2, stimulus_line,'y','LineWidth',1.5)
set(gca,'FontSize',15)
title("Inhibitory Population",'FontSize', 20)
xlabel("Time (mS)",'FontSize', 15)
ylabel("Activity (Hz)",'FontSize', 15)
ylim([0,0.6]);

subplot(2,2,2)
plot([1:7000],E_no(4,1:7000),'r',[7001:27000],E_no(4,7001:27000),'b',point_1, stimulus_line,'y',point_2, stimulus_line,'y','LineWidth',1.5)
set(gca,'FontSize',15)
title("Excitatory Population",'FontSize', 20)
xlabel("Time (mS)",'FontSize', 15)
ylabel("Activity (Hz)",'FontSize', 15)
ylim([0,0.6]);

subplot(2,2,4)
plot([1:7000],I_no(4,1:7000),'r',[7001:27000],I_no(4,7001:27000),'b',point_1, stimulus_line,'y',point_2, stimulus_line,'y','LineWidth',1.5)
set(gca,'FontSize',15)
title("Inhibitory Population",'FontSize', 20)
xlabel("Time (mS)",'FontSize', 15)
ylabel("Activity (Hz)",'FontSize', 15)
ylim([0,0.6]);
