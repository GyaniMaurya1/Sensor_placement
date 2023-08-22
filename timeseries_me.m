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

% Initialize variables for slope, intercept, RMSE, and R-squared
all_rmse = [];
all_slope = [];
all_intercept = [];
all_rsqure = [];

% Calculate slope, intercept, RMSE, and R-squared for each PM sensor
for i = 1:size(pm_data,2)
    G = fitlm(bam_data(:,1),pm_data(:,i));
    rmse = G.RMSE;
    slope = G.Coefficients.Estimate(2);
    intercept = G.Coefficients.Estimate(1);
    Rsquare = G.Rsquared.Adjusted;
    all_rmse = [all_rmse; rmse];
    all_slope = [all_slope; slope];
    all_intercept = [all_intercept; intercept];
    all_rsqure = [all_rsqure; Rsquare];
end

% Threshold values and other parameters
x1 = [0 45];
s1 = [1.35 1.35];
s2 = [0.65 0.65];
i1 = [-10 -10];
i2 = [10 10];
r1 = [0.7 0.7];
rmse1 = [7 7];

% Correlation calculation
bam_sen = [bam_data(:,1),pm_data];
[r1, p1] = corrplot(bam_sen(:,1:10));
rsqure = r1 .* r1;

final_name = [{'EBAM'};name];

% Define time range
t1 = datetime(2023,04,05,17,0,0);
t2 = datetime(2023,04,23,23,0,0);
t = t1:caldays(1):t2;
t = t1:hours(1):t2;
date_new = t';
xx = date_new(:,1);
day = datenum(xx);

% Plotting
figure;
plot(day,pm_data);
datetick('x', 'dd/mm HH:MM','keeplimits');
set(gca, 'TickDir', 'out', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.5);
ylabel('PM_{2.5} Conc. (\mug*m^{-3})', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');
hold on
plot(day,bam_data, '-k', 'LineWidth', 2);
title('Airveda devices 9 devices _5-23 April', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');
hold on

figure;
plot(day,rh_data);
datetick('x', 'dd/mm HH:MM','keeplimits');
set(gca, 'TickDir', 'out', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.5);
ylabel('Relative Humidity (%)', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');
hold on
plot(day,rh_vai_sen, '-k', 'LineWidth', 2);
hold on

figure;
plot(day,temp_data);
datetick('x', 'dd/mm HH:MM','keeplimits');
set(gca, 'TickDir', 'out', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.5);
ylabel('T (^{o}C)', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');
hold on
plot(day, temp_vai_sen, '-k', 'LineWidth', 2);
ylim([0 45])

% figure;
% h = heatmap(rsqure);
% h.Colormap = parula;  % Change the colormap to parula
% h.CellLabelFormat = '%.2f';
% h.CellLabelColor = 'k';
% h.FontSize = 14;
% h.XDisplayLabels = final_name(1:10,1);
% h.YDisplayLabels = final_name(1:10,1);
