%% Frodo project
% Smilja Stokanovic
% May, 2025
close all;
%clear all;
clc;
SubjectTimestamps;

%%

folderPath='C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection';
%%

fileList=dir(fullfile(folderPath, '*txt'));
fs = 100; %Sampling frequency
k=3;
fileNames=cell(1,length(fileList));
%'1503_01_gazedata_output.txt''1903_07_gazedata_output.txt'
%'1503_01_gazedata_output.txt','1503_02_gazedata_output.txt'
specificFiles = {'1703_01_gazedata_output.txt', '1703_02_gazedata_output.txt', ...
                     '1703_03_gazedata_output.txt','1703_05_gazedata_output.txt', '1703_06_gazedata_output.txt', ...
                     '1703_07_gazedata_output.txt', '1703_08_gazedata_output.txt', '1803_01_gazedata_output.txt', '1803_02_gazedata_output.txt', ...
                     '1803_03_gazedata_output.txt', '1803_04_gazedata_output.txt', '1803_05_gazedata_output.txt', '1903_01_gazedata_output.txt', ...
                     '1903_02_gazedata_output.txt','1903_03_gazedata_output.txt','1903_05_gazedata_output.txt',...
                     '1903_07_gazedata_output.txt','1903_08_gazedata_output.txt','2003_01_gazedata_output.txt',...
                     '2003_02_gazedata_output.txt','2003_03_gazedata_output.txt','2003_04_gazedata_output.txt','2003_06_gazedata_output.txt',...
                     '2003_07_gazedata_output.txt','2003_08_gazedata_output.txt'};
%%

%%
fi_1=95/1920;
fi_2=63/1080;
%%
for i = 1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name;  
    [~, fileNameWithoutExt, ~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    fileNames{i} = fileNameWithoutExt;
    data_read = readmatrix(filePath);

    if ismember(fullFileName, specificFiles)
        data_ride.(fileNameWithoutExt).t = data_read(:, 1); 
        x_norm = (data_read(:, 2)-min(data_read(:, 2))) / (max(data_read(:, 2)) - min(data_read(:, 2)));
        y_norm = (data_read(:, 3)-min(data_read(:, 3))) / (max(data_read(:, 3)) - min(data_read(:, 3)));
        data_ride.(fileNameWithoutExt).x = x_norm * 1920;
        data_ride.(fileNameWithoutExt).y = y_norm * 1080;

        t = data_ride.(fileNameWithoutExt).t;

        [~, data_ride.(fileNameWithoutExt).StartBaselineIdx] = min(abs(t - data.(fileNameWithoutExt).StartBaseline));
        [~, data_ride.(fileNameWithoutExt).EndBaselineIdx]   = min(abs(t - data.(fileNameWithoutExt).EndBaseline));
        [~, data_ride.(fileNameWithoutExt).StartRideIdx]     = min(abs(t - data.(fileNameWithoutExt).StartRide));
        [~, data_ride.(fileNameWithoutExt).EndRideIdx]       = min(abs(t - data.(fileNameWithoutExt).EndRide));
    end
end
%%
for i = 1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name;  
    [~, fileNameWithoutExt, ~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);  

    if ismember(fullFileName, specificFiles)
        % Extract baseline segment
        x = data_ride.(fileNameWithoutExt).x(data_ride.(fileNameWithoutExt).StartRideIdx:data_ride.(fileNameWithoutExt).EndRideIdx);
        y = data_ride.(fileNameWithoutExt).y(data_ride.(fileNameWithoutExt).StartRideIdx:data_ride.(fileNameWithoutExt).EndRideIdx);
        t = data_ride.(fileNameWithoutExt).t(data_ride.(fileNameWithoutExt).StartRideIdx:data_ride.(fileNameWithoutExt).EndRideIdx);
        data_ride.(fileNameWithoutExt).x_ride = x;
        data_ride.(fileNameWithoutExt).y_ride = y;
        data_ride.(fileNameWithoutExt).t_ride = t;
        maxNaNDuration = 2 * fs;  % 5 s cutoff for NaN
        gazeX = x(:);
        gazeY = y(:);
        N = length(gazeX);

        nanMask = isnan(gazeX) & isnan(gazeY);
        nanRegions = bwconncomp(nanMask);

        longNaNs = false(N,1);
        for k = 1:nanRegions.NumObjects
            idx = nanRegions.PixelIdxList{k};
            if numel(idx) >= maxNaNDuration
                longNaNs(idx) = true; % remove only long NaNs
            end
        end

        keepMask = ~longNaNs;

        gazeX_clean = gazeX(keepMask);
        gazeY_clean = gazeY(keepMask);


        time_clean = (0:length(gazeX_clean)-1)/fs;
        gazeX_clean = gazeX_clean(:);
        gazeY_clean = gazeY_clean(:);
        data_ride.(fileNameWithoutExt).x_clean = gazeX_clean;
        data_ride.(fileNameWithoutExt).y_clean = gazeY_clean;
        data_ride.(fileNameWithoutExt).t_clean = time_clean;        

        % Apply filtering on concatenated valid data (ignores NaNs automatically)
        data_ride.(fileNameWithoutExt).x_filt = sgolayfilt(gazeX_clean, 3, 11);
        data_ride.(fileNameWithoutExt).y_filt = sgolayfilt(gazeY_clean, 3, 11);
    end
end

%%

for i=1:length(fileList)
    fh=figure(i);
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);  
    if ismember(fullFileName, specificFiles) 

        fh.WindowState='maximized';
        t0 = data_ride.(fileNameWithoutExt).t_ride;
        t0 = t0 - t0(1); 
            subplot(2,1,1)
                plot(data_ride.(fileNameWithoutExt).t_ride, data_ride.(fileNameWithoutExt).x_ride,'Color', '#1a80bb', 'LineWidth',2); hold on;
                grid on
                title('Horizontal Eye Tracker Data','FontSize',22)
                ylabel({'Amplitude', '[pixels]'}, 'Fontsize', 22)
                set(gca, 'FontSize', 22); 
                ylim([0 2000])

            subplot(2,1,2)
                plot(data_ride.(fileNameWithoutExt).t_ride, data_ride.(fileNameWithoutExt).y_ride,'Color', '#1a80bb','LineWidth',2); hold on;
                grid on
                title('Vertical Eye Tracker Data','FontSize',22)
                xlabel('Time [s]', 'Fontsize', 22)
                ylabel({'Amplitude', '[pixels]'}, 'Fontsize', 22)
                set(gca, 'FontSize', 22); 
                ylim([0 1200])

    end
    jpg_filename = sprintf('%sRawDataRide.jpg', (fileNameWithoutExt));
    eps_filename = sprintf('%sRawDataRide.eps', (fileNameWithoutExt));
    saveas(gcf, jpg_filename, 'jpg');
    saveas(gcf, eps_filename,'epsc');

end

close all
%%
for i=1:length(fileList)
    fh=figure(i);
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);  
    if ismember(fullFileName, specificFiles) 

        fh.WindowState='maximized';
 
        t1 = data_ride.(fileNameWithoutExt).t_clean;
        t1 = t1 - t1(1); 
            subplot(2,1,1)
                plot(data_ride.(fileNameWithoutExt).t_clean, data_ride.(fileNameWithoutExt).x_clean,'Color', '#1a80bb', 'LineWidth',2); hold on;
                grid on
                plot(data_ride.(fileNameWithoutExt).t_clean, data_ride.(fileNameWithoutExt).x_filt,'Color', '#800074'); hold off;
                title('Horizontal Eye Tracker Data','FontSize',22) 
                ylim([0 2000])
%                 Lgnd = legend('Measured data', 'Filtered data','Location','southwest','FontSize',24);
%                 Lgnd.Position(1) = -0.05;
%                 Lgnd.Position(2) = 0.4;
%                 xlabel('Time [s]', 'Fontsize', 22)
                ylabel({'Amplitude', '[pixels]'}, 'Fontsize', 22)
                set(gca, 'FontSize', 22); 
            subplot(2,1,2)
                plot(data_ride.(fileNameWithoutExt).t_clean, data_ride.(fileNameWithoutExt).y_clean,'Color', '#1a80bb','LineWidth',2); hold on;
                grid on
                plot(data_ride.(fileNameWithoutExt).t_clean, data_ride.(fileNameWithoutExt).y_filt,'Color', '#800074'); hold off;
                title('Vertical Eye Tracker Data','FontSize',22)
                ylim([0 1200])
                Lgnd = legend('Measured data', 'Filtered data','Location','southwest','FontSize',16);
                Lgnd.Position(1) = -0.05;
                Lgnd.Position(2) = 0.42;      
                xlabel('Time [s]', 'Fontsize', 22)
                ylabel({'Amplitude', '[pixels]'}, 'Fontsize', 22)
                set(gca, 'FontSize', 22); 
    end
    jpg_filename = sprintf('%sFilteredRide.jpg', (fileNameWithoutExt));
    eps_filename = sprintf('%sFilteredRide.eps', (fileNameWithoutExt));
    saveas(gcf, jpg_filename, 'jpg');
    saveas(gcf, eps_filename,'epsc');

end

close all
%% Theta
dt = 1/fs;

for i=1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    if ismember(fullFileName, specificFiles) 

        data_ride.(fileNameWithoutExt).x_dot = gradient(data_ride.(fileNameWithoutExt).x_filt, dt);
        data_ride.(fileNameWithoutExt).y_dot = gradient(data_ride.(fileNameWithoutExt).y_filt, dt);
        data_ride.(fileNameWithoutExt).theta_dot = sqrt((fi_1*data_ride.(fileNameWithoutExt).x_dot).^2 + (fi_2*data_ride.(fileNameWithoutExt).y_dot).^2);
        med_val = median(data_ride.(fileNameWithoutExt).theta_dot);

        % Apply filtering: keep only values between median and 1000
        theta = data_ride.(fileNameWithoutExt).theta_dot;
        theta(theta < med_val | theta > 1000) = 0;
        data_ride.(fileNameWithoutExt).theta_dot = theta;

        data_ride.(fileNameWithoutExt).saccades = saccade_detection_function_ride([data_ride.(fileNameWithoutExt).x_filt, data_ride.(fileNameWithoutExt).y_filt],data_ride.(fileNameWithoutExt).t_clean, data.(fileNameWithoutExt).saccades.SACC.PT,data.(fileNameWithoutExt).saccades.SACC.noise_mean,data.(fileNameWithoutExt).saccades.SACC.noise_std);
        data_ride.(fileNameWithoutExt).sigma_x=std(data_ride.(fileNameWithoutExt).x_filt);
        data_ride.(fileNameWithoutExt).sigma_y=std(data_ride.(fileNameWithoutExt).y_filt);
        data_ride.(fileNameWithoutExt).mean_x=mean(data_ride.(fileNameWithoutExt).x_filt);
        data_ride.(fileNameWithoutExt).mean_y=mean(data_ride.(fileNameWithoutExt).y_filt);
        data_ride.(fileNameWithoutExt).rho=corr(data_ride.(fileNameWithoutExt).x_filt,data_ride.(fileNameWithoutExt).y_filt);
        data_ride.(fileNameWithoutExt).BCEA=2*pi*k*data_ride.(fileNameWithoutExt).sigma_x*data_ride.(fileNameWithoutExt).sigma_y*sqrt(1-data_ride.(fileNameWithoutExt).rho^2);
    end
end

%
for i = 1:length(fileList) 
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~, fileNameWithoutExt, ~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);  

    fh = figure(i);
    fh.WindowState = 'maximized';
    if ismember(fullFileName, specificFiles) 
        plot(data_ride.(fileNameWithoutExt).t_clean, data_ride.(fileNameWithoutExt).theta_dot,'Color', '#1a80bb', 'Linewidth', 2);
        grid on; 
        axis tight; 
        xlabel('Time [s]', 'FontSize', 49);
        ylabel('Angular velocity [°/s]', 'FontSize', 49);
        set(gca, 'FontSize', 30);
        ylim([0 1200]) 
    end
    jpg_filename = sprintf('%sVelocityRide.jpg', fileNameWithoutExt);
    eps_filename = sprintf('%sVelocityRide.eps', fileNameWithoutExt);
    saveas(gcf, jpg_filename, 'jpg');
    saveas(gcf, eps_filename, 'epsc');
end

%% Plotting results
close all
for i = 1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    if ismember(fullFileName, specificFiles) 

        fh=figure(i);
        fh.WindowState='maximized';
        plot(data_ride.(fileNameWithoutExt).saccades.GAZE.t, data_ride.(fileNameWithoutExt).saccades.GAZE.vel,'Color', '#1a80bb','Linewidth', 2); hold on;
        hold on
        grid on
        plot(data_ride.(fileNameWithoutExt).saccades.GAZE.t(data_ride.(fileNameWithoutExt).saccades.SACC.peak_idxs),data_ride.(fileNameWithoutExt).saccades.SACC.peak_vals,'r.', 'Markersize',15);
        plot(data_ride.(fileNameWithoutExt).saccades.GAZE.t(data_ride.(fileNameWithoutExt).saccades.SACC.onsets),data_ride.(fileNameWithoutExt).saccades.GAZE.vel(data_ride.(fileNameWithoutExt).saccades.SACC.onsets),'b.', 'Markersize', 15);
        plot(data_ride.(fileNameWithoutExt).saccades.GAZE.t(data_ride.(fileNameWithoutExt).saccades.SACC.offsets),data_ride.(fileNameWithoutExt).saccades.GAZE.vel(data_ride.(fileNameWithoutExt).saccades.SACC.offsets),'k.', 'Markersize',15); hold off;
        if ~isnan(data.(fileNameWithoutExt).saccades.SACC.PT)
            yline(data.(fileNameWithoutExt).saccades.SACC.PT, 'k--', 'Linewidth', 2)
        end
        lgd=legend('Velocity','Peak','Onset','Offset','Threshold');
        lgd.NumColumns = 3;
        xlim([min(data_ride.(fileNameWithoutExt).saccades.GAZE.t) max(data_ride.(fileNameWithoutExt).saccades.GAZE.t)])
        ylim([0 max(data_ride.(fileNameWithoutExt).saccades.GAZE.vel)+200])
        xlabel('Time [s]', 'FontSize',30);
        ylabel('Angular Velocity [°/s]', 'FontSize',30);
        jpg_filename = sprintf('%sSaccadesRide.jpg', (fileNameWithoutExt));
        eps_filename = sprintf('%sSaccadesRide.eps', (fileNameWithoutExt));
        set(gca, 'FontSize', 30);
    end
    saveas(gcf, jpg_filename, 'jpg');
    saveas(gcf, eps_filename,'epsc');

end
%% Table packing

subjectIDs={};
mean_amp_table=[];
mean_pvamp_table=[];
mean_pvdur_table=[];
mean_fdur_table=[];
std_amp_table=[];
std_pvamp_table=[];
std_pvdur_table=[];
std_fdur_table=[];
median_amp_table=[];
median_pvamp_table=[];
median_pvdur_table=[];
median_fdur_table=[];
NumSacc_table=[];
STD_x_table=[];
STD_y_table=[];
MEAN_x_table=[];
MEAN_y_table=[];
RHO_table=[];
BCEA_table=[];
subjectIndex = 1; 

for i = 1:length(fileNames) 
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name;     
    [~, fileNameWithoutExt, ~] = fileparts(fullFileName);  
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    if ismember(fullFileName, specificFiles) 

        AMP = data_ride.(fileNameWithoutExt).saccades.SACC.amplitudes';
        PVAMP = data_ride.(fileNameWithoutExt).saccades.SACC.peak_vals;
        PVDUR = data_ride.(fileNameWithoutExt).saccades.SACC.durations';
        FDUR = [NaN;data_ride.(fileNameWithoutExt).saccades.SACC.gaze_times'];
        BCEA_map=data_ride.(fileNameWithoutExt).BCEA;
        close all
        featuremap = table(AMP,PVAMP,PVDUR);
        featuremap_duration=table(FDUR);
        featuremap = table(AMP,PVAMP,PVDUR);
        featuremap_duration=table(FDUR);
        csvFilePath = [(fileNameWithoutExt), '_RideParameters.csv'];
        writetable(featuremap,csvFilePath,'Delimiter',',');
        csvFilePath_duration = [(fileNameWithoutExt), '_RideDuration.csv'];
        writetable(featuremap_duration,csvFilePath_duration,'Delimiter',',');


        mean_amp=mean(AMP);
        mean_pvamp=mean(PVAMP);
        mean_pvdur=mean(PVDUR);
        mean_fdur=nanmean(FDUR);

        std_amp=std(AMP);
        std_pvamp=std(PVAMP);
        std_pvdur=std(PVDUR);
        std_fdur=nanstd(FDUR);
        median_amp=median(AMP);
        median_pvamp=median(PVAMP);
        median_pvdur=median(PVDUR);
        median_fdur=nanmedian(FDUR);
        STD_x=data_ride.(fileNameWithoutExt).sigma_x;
        STD_y=data_ride.(fileNameWithoutExt).sigma_y;
        MEAN_x=data_ride.(fileNameWithoutExt).mean_x;
        MEAN_y=data_ride.(fileNameWithoutExt).mean_y;
        RHO=data_ride.(fileNameWithoutExt).rho;
        BCEA=data_ride.(fileNameWithoutExt).BCEA;
        close all
        subjectIDs{end + 1} = fileNameWithoutExt;

        mean_amp_table(subjectIndex)=mean_amp;
        mean_pvamp_table(subjectIndex)=mean_pvamp;
        mean_pvdur_table(subjectIndex)=mean_pvdur;
        mean_fdur_table(subjectIndex)=mean_fdur;
        std_amp_table(subjectIndex)=std_amp;
        std_pvamp_table(subjectIndex)=std_pvamp;
        std_pvdur_table(subjectIndex)=std_pvdur;
        std_fdur_table(subjectIndex)=std_fdur;
        median_amp_table(subjectIndex)=median_amp;
        median_pvamp_table(subjectIndex)=median_pvamp;
        median_pvdur_table(subjectIndex)=median_pvdur;
        median_fdur_table(subjectIndex)=median_fdur;
        STD_x_table(subjectIndex)=STD_x;
        STD_y_table(subjectIndex)=STD_y;
        MEAN_x_table(subjectIndex)=MEAN_x;
        MEAN_y_table(subjectIndex)=MEAN_y;
        RHO_table(subjectIndex)=RHO;
        BCEA_table(subjectIndex)=BCEA;
        NumSacc_table(subjectIndex)=length(data_ride.(fileNameWithoutExt).saccades.SACC.amplitudes);

        BCEAmap= table(mean_amp,std_amp,mean_pvamp,std_pvamp, mean_pvdur,std_pvdur, mean_fdur,std_fdur,STD_x,STD_y,MEAN_x,MEAN_y,RHO,BCEA);
        medianmap=table(median_amp, median_pvamp, median_pvdur, median_fdur);
        mediancsvFilePath = [(fileNameWithoutExt),'_median', '.csv'];
        writetable(medianmap,mediancsvFilePath,'Delimiter',',');
        BCEAcsvFilePath = [(fileNameWithoutExt),'_BCEA', '.csv'];
        writetable(BCEAmap,BCEAcsvFilePath,'Delimiter',',');
        subjectIndex = subjectIndex + 1;

    end
end
subjectIDs      = subjectIDs(:);
mean_amp_table  = mean_amp_table(:);
std_amp_table   = std_amp_table(:);
median_amp_table = median_amp_table(:);
mean_pvamp_table = mean_pvamp_table(:);
std_pvamp_table  = std_pvamp_table(:);
median_pvamp_table = median_pvamp_table(:);
mean_pvdur_table = mean_pvdur_table(:);
std_pvdur_table  = std_pvdur_table(:);
median_pvdur_table = median_pvdur_table(:);
mean_fdur_table = mean_fdur_table(:);
std_fdur_table  = std_fdur_table(:);
median_fdur_table = median_fdur_table(:);
NumSacc_table   = NumSacc_table(:);
FeaturesTable = table(subjectIDs, mean_amp_table, std_amp_table, median_amp_table, ...
    mean_pvamp_table, std_pvamp_table, median_pvamp_table, ...
    mean_pvdur_table, std_pvdur_table, median_pvdur_table, ...
    mean_fdur_table, std_fdur_table, median_fdur_table, ...
    NumSacc_table,...
    'VariableNames', {'SubjectID', 'MeanSaccAmp', 'StdSaccAmp', 'MedianSaccAmp', ...
                      'MeanPeakVelAmp','StdPeakVelAmp','MedianPeakVelAmp', ...
                      'MeanSaccDur','StdSaccDur','MedianSaccDur', ...
                      'MeanFixDur','StdFixDur','MedianFixDur','NumSacc'});
featurescsvFilePath = ['FeaturesRide', '.csv'];
writetable(FeaturesTable,featurescsvFilePath,'Delimiter',',');
subjectIDs   = subjectIDs(:);
MEAN_x_table = MEAN_x_table(:);
STD_x_table  = STD_x_table(:);
MEAN_y_table = MEAN_y_table(:);
STD_y_table  = STD_y_table(:);
RHO_table    = RHO_table(:);
BCEA_table   = BCEA_table(:);

FeaturesTable_BCEA = table(subjectIDs, MEAN_x_table, STD_x_table, MEAN_y_table, ...
    STD_y_table, RHO_table, BCEA_table, ...
    'VariableNames', {'SubjectID', 'MeanHoriz', 'StdHoriz', 'MeanVert', 'StdVert', 'RHO', 'BCEA'});
featurescsvFilePath = ['FeaturesRide_BCEA', '.csv'];
writetable(FeaturesTable_BCEA,featurescsvFilePath,'Delimiter',',');%%%%

%%
timeWindow = 1; 
subjectIDs = {};  
totalSaccadesPerWindow = [];  
meanSaccadesPerWindow = [];  
stdSaccadesPerWindow = [];  
medianSaccadesPerWindow = [];
subjectIndex = 1; 

for i = 1:length(fileNames) 
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name;     
    [~, fileNameWithoutExt, ~] = fileparts(fullFileName);  
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 

    if ismember(fullFileName, specificFiles) 
        time = data_ride.(fileNameWithoutExt).t_clean; 
        peakTimes = time(data_ride.(fileNameWithoutExt).saccades.SACC.peak_idxs);  
        startTime = min(time);
        totalTime = max(time);
        windowEdges = startTime:timeWindow:totalTime;  
        saccadesPerWindow = histcounts(peakTimes, windowEdges);

        data_ride.(fileNameWithoutExt).saccadesPerWindow = saccadesPerWindow;
        data_ride.(fileNameWithoutExt).SumSaccadesPerWindow = sum(saccadesPerWindow);

        fh = figure(i); 
        fh.WindowState = 'maximized';
        bar(windowEdges(1:end-1), saccadesPerWindow, 'histc');  
        xlabel('Time [s]', 'FontSize', 30);
        ylabel('Number of Saccades', 'FontSize', 30);
        grid on;
        set(gca, 'FontSize', 22); 

        mean_saccadesPerWindow = mean(saccadesPerWindow);
        std_saccadesPerWindow = std(saccadesPerWindow);
        median_saccadesPerWindow = median(saccadesPerWindow);

        data_ride.(fileNameWithoutExt).mean_saccadesPerWindow = mean_saccadesPerWindow;
        data_ride.(fileNameWithoutExt).std_saccadesPerWindow = std_saccadesPerWindow;
        data_ride.(fileNameWithoutExt).median_saccadesPerWindow = median_saccadesPerWindow;

        subjectIDs{end + 1} = fileNameWithoutExt;
        totalSaccadesPerWindow(subjectIndex) = data_ride.(fileNameWithoutExt).SumSaccadesPerWindow;
        meanSaccadesPerWindow(subjectIndex) = mean_saccadesPerWindow;
        stdSaccadesPerWindow(subjectIndex) = std_saccadesPerWindow;
        medianSaccadesPerWindow(subjectIndex) = median_saccadesPerWindow;

        jpg_filename = sprintf('%s_SaccadesInTimeRide.jpg', fileNameWithoutExt);
        eps_filename = sprintf('%s_SaccadesInTimeRide.eps', fileNameWithoutExt);
        saveas(gcf, jpg_filename, 'jpg');
        saveas(gcf, eps_filename, 'epsc');

        subjectIndex = subjectIndex + 1;
    end

end

resultTable = table(subjectIDs', totalSaccadesPerWindow', meanSaccadesPerWindow', stdSaccadesPerWindow', medianSaccadesPerWindow','VariableNames', {'SubjectID', 'TotalSaccadesPerWindow', 'MeanSaccadesPerWindow', 'StdSaccadesPerWindow','MedianSaccadesPerWindow'});
saccadescsvFilePath = ['NumSaccadesRide', '.csv'];
writetable(resultTable,saccadescsvFilePath,'Delimiter',',');

close all



