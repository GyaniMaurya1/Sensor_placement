% These commands clear all variables, close all figures, and clear the command window.
clear all;close all;clc

% The code reads a CSV file named  into a table  and 
% extracts the sensor IDs from the table's variable names.
% It then processes the IDs and generates a final name for each sensor.
Table=readtable('Airveda devices 9 devices _5-23 April.csv'); 
variables =Table.Properties.VariableNames;
sensors_id=variables(1,2:3:size(variables,2))'; 
cut=cell2mat(sensors_id);
name=cellstr(cut(:,13:15)); 
final_name=['E-BAM';name]

full_name=cut(:,6:15);

% The code reads data from the same CSV file as above into the matrices
% airveda_data and airveda_date. It retrieves the dimensions of airveda_data
% and airveda_date and extracts a subset of airveda_date into xx.
[airveda_data airveda_date]=xlsread('Airveda devices 9 devices _5-23 April.csv');
dimension=size(airveda_data);
sensor_date=size(airveda_date(:,1));
cutdate=airveda_date(2:sensor_date(1),1)

% These lines convert the extracted dates into numerical format and then into a formatted string.
date=datenum(cutdate);

date_new=datestr(date,'dd-mm-yyyy HH:MM:SS');

%This code separates PM, temperature, and RH data from airveda_data and 
% assigns them to separate variables. It also removes any zeros in the 
% PM data and sets them to NaN (not a number). Similarly, it removes temperature values
% greater than 40 and RH values greater than 100, replacing them with NaN.

pm_data=airveda_data(:,1:3:dimension(2));
temp_data=airveda_data(:,2:3:dimension(2));

rh_data=airveda_data(:,3:3:dimension(2)); 
pm_data(pm_data==0)=NaN;

temp_data(temp_data>40)=NaN;
rh_data(rh_data>100)=NaN;

% Code reads bam data and get the value and string into different variable
[bam_data bam_date]=xlsread('EBAM_CESE_raw data file_5-23 April 2023.xlsx');


% Code reads vaishala data and get the value and string into different variable
[vaisala_data vaisala_date]=xlsread('Vaisala_data_file_5-23_April 2023.csv');

final_vaisala=vaisala_data; 

 final_vaisala(final_vaisala(:,1)>100)=NaN;
 rh_vai_sen=final_vaisala(:,1);

 temp_vai_sen=final_vaisala(:,2);


%Now put all data into one matrix
 pm_bam_sen=[bam_data,pm_data];

rh_sen=[rh_vai_sen,rh_data];

temp_sen=[temp_vai_sen,temp_data];

% subplot(3,1,1)
h1=boxplot(pm_bam_sen);
set(h1,{'linew'},{2})
set(gca,'tickdir','out','FontName','Helvetica','fontsize',16,'fontweight','bold','linewidth',1.5);
ylabel('PM_{2.5} conc (\mugm^{-3})','FontName','Helvetica','fontsize',16,'fontweight','b');
title('Airveda devices 9 devices _5-23 April','FontName','Helvetica','fontsize',16,'fontweight','b');

ylim([0 250])
hold on
figure;

% subplot(3,1,2)
h1=boxplot(rh_sen);
set(h1,{'linew'},{2})
set(gca,'tickdir','out','FontName','Helvetica','fontsize',16,'fontweight','bold','linewidth',1.5);
ylabel('RH(%)','FontName','Helvetica','fontsize',16,'fontweight','b');
title('Airveda devices 9 devices _5-23 April','FontName','Helvetica','fontsize',16,'fontweight','b');
ylim([0 100])
hold on
figure;

% subplot(3,1,3)
h1=boxplot(temp_sen);
set(h1,{'linew'},{2})
set(gca,'tickdir','out','FontName','Helvetica','fontsize',16,'fontweight','bold','linewidth',1.5);
ylabel('T (^{o}C)','FontName','Helvetica','fontsize',16,'fontweight','b');
xlabel('Sensor no','FontName','Helvetica','fontsize',16,'fontweight','b');
title('Airveda devices 9 devices _5-23 April','FontName','Helvetica','fontsize',16,'fontweight','b');
ylim([0 50])