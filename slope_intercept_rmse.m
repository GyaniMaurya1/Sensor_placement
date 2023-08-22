clear all; close all; clc

% Read sensor IDs from the file
T = readtable('Airveda devices 9 devices _5-23 April.csv');
vars = T.Properties.VariableNames;
sns_id = vars(1,2:3:size(vars,2))';
x = cell2mat(sns_id);
name = cellstr(x(:,13:15));
full_name = x(:,6:15);

% Read all sensor data
[airveda_data, airveda_date] = xlsread('Airveda devices 9 devices _5-23 April.csv');
dim = size(airveda_data);
s_date = size(airveda_date(:,1));
xx = airveda_date(2:s_date(1),1);

% Convert date to numerical format
date = datenum(xx);
date_new = datestr(date, 'dd-mm-yyyy HH:MM:SS');

% Extract PM, RH, and T data
pm_data = airveda_data(:,1:3:dim(2));
temp_data = airveda_data(:,2:3:dim(2));
rh_data = airveda_data(:,3:3:dim(2));
pm_data(pm_data == 0) = NaN;
temp_data(temp_data > 40) = NaN;
rh_data(rh_data > 100) = NaN;

% Read BAM-1020 data
[bam_data, bam_date] = xlsread('EBAM_CESE_raw data file_5-23 April 2023.xlsx');

% Read Vaisala data
[vaisala_data, vaisala_date] = xlsread('Vaisala_data_file_5-23_April 2023.csv');
final_vaisala = vaisala_data;
final_vaisala(final_vaisala(:,1) > 100) = NaN;
rh_vai_sen = final_vaisala(:,1);
temp_vai_sen = final_vaisala(:,2);

% Slope and intercept and RMSE Calculation
all_slope = [];
all_intercept = [];
all_rsqure = [];
all_rmse = [];
for i = 1:size(pm_data,2) 
    G = fitlm(bam_data,pm_data(:,i));
    rmse = G.RMSE; 
    slope = G.Coefficients.Estimate(2); 
    intercept = G.Coefficients.Estimate(1); 
    Rsquare = G.Rsquared.Adjusted;
    all_rmse = [all_rmse; rmse];
    all_slope = [all_slope; slope]; 
    all_intercept = [all_intercept; intercept];
    all_rsqure = [all_rsqure; Rsquare];
end

x1 = [0 45]; s1 = [1.35 1.35]; s2 = [0.65 0.65];
x1 = [0 45]; i1 = [-10 -10]; i2 = [10 10];
x1 = [0 45]; r1 = [0.7 0.7];
rmse1 = [7 7];

figure(1)
plot(all_slope, '-ob', 'linewidth', 1.5);
hold on
plot(x1, s1, '--b', 'linewidth', 1.5)
hold on
plot(x1, s2, '--b', 'linewidth', 1.5)
xlim([0 7]); ylim([0.5 1.8])
xticks([1:1:45]);
xticklabels(name)
set(gca, 'tickdir', 'out', 'FontName', 'Arial', 'fontsize', 12, 'fontweight', 'bold', 'linewidth', 1.5);
ylabel('Slope', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');
title('Slope - Airveda devices 9 devices _5-23 April', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');

figure(2)
plot(all_intercept, '-og', 'linewidth', 1.5); % Modified color to green
hold on
plot(x1, i1, '--b', 'linewidth', 1.5)
hold on
plot(x1, i2, '--b', 'linewidth', 1.5)
xlim([0 7]); ylim([-40 40])
xticks([1:1:7])
xticklabels(name)
set(gca, 'tickdir', 'out', 'FontName', 'Arial', 'fontsize', 12, 'fontweight', 'bold', 'linewidth', 1.5);
ylabel('Intercept', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');
title('Intercept - Airveda devices 9 devices _5-23 April', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');

figure(3)
plot(all_rmse, '-oc', 'linewidth', 1.5); % Modified color to cyan
hold on
plot(x1, rmse1, '--b', 'linewidth', 1.5)
xlim([0 7]); ylim([0 26])
xticks([1:1:7])
xticklabels(name)
set(gca, 'tickdir', 'out', 'FontName', 'Arial', 'fontsize', 12, 'fontweight', 'bold', 'linewidth', 1.5);
ylabel('RMSE', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');
title('RMSE - Airveda devices 9 devices _5-23 April', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');

figure(4)
plot(all_rsqure, '-om', 'linewidth', 1.5); % Modified color to magenta
hold on
plot(x1, r1, '--b', 'linewidth', 1.5)
xlim([0 7]); ylim([0.3 1])
xticks([1:1:7])
xticklabels(name)
set(gca, 'tickdir', 'out', 'FontName', 'Arial', 'fontsize', 12, 'fontweight', 'bold', 'linewidth', 1.5);
ylabel('R^{2}', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');
xlabel('SensorID', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');
title('R^{2} - Airveda devices 9 devices _5-23 April', 'FontName', 'Arial', 'fontsize', 16, 'fontweight', 'bold');
