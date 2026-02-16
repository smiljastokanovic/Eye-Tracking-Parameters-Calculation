%% Frodo project
% Smilja Stokanovic
% May, 2025
close all;
clc;
% clear all;
SubjectTimestamps;

folderPath='C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection';

fileList=dir(fullfile(folderPath, '*txt'));
fs = 100; %Sampling frequency
k=3;
fileNames=cell(1,length(fileList));
specificFiles = {'1703_01_gazedata_output.txt', '1703_02_gazedata_output.txt', ...
                     '1703_03_gazedata_output.txt','1703_05_gazedata_output.txt', '1703_06_gazedata_output.txt', ...
                     '1703_07_gazedata_output.txt', '1703_08_gazedata_output.txt', '1803_01_gazedata_output.txt', '1803_02_gazedata_output.txt', ...
                     '1803_03_gazedata_output.txt', '1803_04_gazedata_output.txt', '1803_05_gazedata_output.txt', '1903_01_gazedata_output.txt', ...
                     '1903_02_gazedata_output.txt','1903_03_gazedata_output.txt','1903_05_gazedata_output.txt',...
                     '1903_07_gazedata_output.txt','1903_08_gazedata_output.txt','2003_01_gazedata_output.txt',...
                     '2003_02_gazedata_output.txt','2003_03_gazedata_output.txt','2003_04_gazedata_output.txt','2003_06_gazedata_output.txt',...
                     '2003_07_gazedata_output.txt','2003_08_gazedata_output.txt'};

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
        data_baseline.(fileNameWithoutExt).t = data_read(:, 1); 
        x_norm = (data_read(:, 2)-min(data_read(:, 2))) / (max(data_read(:, 2)) - min(data_read(:, 2)));
        y_norm = (data_read(:, 3)-min(data_read(:, 3))) / (max(data_read(:, 3)) - min(data_read(:, 3)));
        data_baseline.(fileNameWithoutExt).x = x_norm * 1920;
        data_baseline.(fileNameWithoutExt).y = y_norm * 1080;

        t = data_baseline.(fileNameWithoutExt).t;
        [~, data_baseline.(fileNameWithoutExt).StartBaselineIdx] = min(abs(t - data.(fileNameWithoutExt).StartBaseline));
        [~, data_baseline.(fileNameWithoutExt).EndBaselineIdx]   = min(abs(t - data.(fileNameWithoutExt).EndBaseline));
        [~, data_baseline.(fileNameWithoutExt).StartRideIdx]     = min(abs(t - data.(fileNameWithoutExt).StartRide));
        [~, data_baseline.(fileNameWithoutExt).EndRideIdx]       = min(abs(t - data.(fileNameWithoutExt).EndRide));
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
        x = data_baseline.(fileNameWithoutExt).x(data_baseline.(fileNameWithoutExt).StartBaselineIdx:data_baseline.(fileNameWithoutExt).EndBaselineIdx);
        y = data_baseline.(fileNameWithoutExt).y(data_baseline.(fileNameWithoutExt).StartBaselineIdx:data_baseline.(fileNameWithoutExt).EndBaselineIdx);
        t = data_baseline.(fileNameWithoutExt).t(data_baseline.(fileNameWithoutExt).StartBaselineIdx:data_baseline.(fileNameWithoutExt).EndBaselineIdx);
        data_baseline.(fileNameWithoutExt).x_baseline = x;
        data_baseline.(fileNameWithoutExt).y_baseline = y;
        data_baseline.(fileNameWithoutExt).t_baseline = t;
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
        data_baseline.(fileNameWithoutExt).x_clean = gazeX_clean;
        data_baseline.(fileNameWithoutExt).y_clean = gazeY_clean;
        data_baseline.(fileNameWithoutExt).t_clean = time_clean;        

        % Apply filtering on concatenated valid data (ignores NaNs automatically)
        data_baseline.(fileNameWithoutExt).x_filt = sgolayfilt(gazeX_clean, 3, 11);
        data_baseline.(fileNameWithoutExt).y_filt = sgolayfilt(gazeY_clean, 3, 11);
    end
end

%%

for i=1:3%length(fileList)
    fh=figure(i);
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);  

    if ismember(fullFileName, specificFiles) 
        fh.WindowState='maximized';

        % Normalize time so that it starts from 0
        t0 = data_baseline.(fileNameWithoutExt).t_baseline;
        t0 = t0 - t0(1);  

        subplot(2,1,1)
            plot(t0, data_baseline.(fileNameWithoutExt).x_baseline,'Color', '#1a80bb', 'LineWidth',2); hold on;
            grid on
            title('Horizontal Eye Tracker Data','FontSize',30)
%             xlabel('Time [s]', 'Fontsize', 22)
            ylabel({'Amplitude', '[pixels]'}, 'Fontsize', 30)
            set(gca,'FontSize',37); 
            xlim([0 900])
            ylim([0 2000])

        subplot(2,1,2)
            plot(t0, data_baseline.(fileNameWithoutExt).y_baseline,'Color', '#1a80bb', 'LineWidth',2); hold on;
            grid on
            title('Vertical Eye Tracker Data','FontSize',30)
            xlabel('Time [s]', 'Fontsize', 30)
            ylabel({'Amplitude', '[pixels]'}, 'Fontsize', 30)
            set(gca,'FontSize',37); 
            xlim([0 900])
            ylim([0 1200])
    end

    jpg_filename = sprintf('%sRawDataBaseline.jpg', (fileNameWithoutExt));
    eps_filename = sprintf('%sRawDataBaseline.eps', (fileNameWithoutExt));
    saveas(gcf, jpg_filename, 'jpg');
    saveas(gcf, eps_filename,'epsc');
end

% close all

%%
for i=1:length(fileList)
    fh=figure(i);
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);  

    if ismember(fullFileName, specificFiles) 
        fh.WindowState='maximized';

        % Normalize clean time to start at 0
        t1 = data_baseline.(fileNameWithoutExt).t_clean;
        t1 = t1 - t1(1); 
        subplot(2,1,1)
            plot(t1, data_baseline.(fileNameWithoutExt).x_clean,'Color','#1a80bb', 'LineWidth',2); hold on;
            plot(t1, data_baseline.(fileNameWithoutExt).x_filt,'Color', '#800074');
            grid on
            title('Horizontal Eye Tracker Data','FontSize',22)
            ylabel({'Amplitude', '[pixels]'}, 'Fontsize', 22)
            set(gca,'FontSize',22); 
%             xlim([0 900])
            ylim([0 2000])

        subplot(2,1,2)
            plot(t1, data_baseline.(fileNameWithoutExt).y_clean,'Color','#1a80bb','LineWidth',2); hold on;
            plot(t1, data_baseline.(fileNameWithoutExt).y_filt,'Color','#800074');
            grid on
            xlabel('Time [s]', 'Fontsize', 22)
            ylabel({'Amplitude', '[pixels]'}, 'Fontsize', 22)
            Lgnd = legend('Measured data', 'Filtered data','Location','southwest','FontSize',16); 
            Lgnd.Position(1) = -0.05; Lgnd.Position(2) = 0.42; 
            title('Vertical Eye Tracker Data','FontSize',22)
            set(gca,'FontSize',22);
%             xlim([0 900])
            ylim([0 1200])

    end

    jpg_filename = sprintf('%sFilteredBaseline.jpg', (fileNameWithoutExt));
    eps_filename = sprintf('%sFilteredBaseline.eps', (fileNameWithoutExt));
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

        data_baseline.(fileNameWithoutExt).x_dot = gradient(data_baseline.(fileNameWithoutExt).x_filt, dt);
        data_baseline.(fileNameWithoutExt).y_dot = gradient(data_baseline.(fileNameWithoutExt).y_filt, dt);
        data_baseline.(fileNameWithoutExt).theta_dot = sqrt((fi_1*data_baseline.(fileNameWithoutExt).x_dot).^2 + (fi_2*data_baseline.(fileNameWithoutExt).y_dot).^2);
        med_val = median(data_baseline.(fileNameWithoutExt).theta_dot);

        % Apply filtering: keep only values between median and 1000
        theta = data_baseline.(fileNameWithoutExt).theta_dot;
        theta(theta < med_val | theta > 1000) = 0;
        data_baseline.(fileNameWithoutExt).theta_dot = theta;

        data_baseline.(fileNameWithoutExt).saccades = saccade_detection_function_baseline([data_baseline.(fileNameWithoutExt).x_filt, data_baseline.(fileNameWithoutExt).y_filt],data_baseline.(fileNameWithoutExt).t_clean, data.(fileNameWithoutExt).saccades.SACC.PT,data.(fileNameWithoutExt).saccades.SACC.noise_mean,data.(fileNameWithoutExt).saccades.SACC.noise_std);
        data_baseline.(fileNameWithoutExt).sigma_x=std(data_baseline.(fileNameWithoutExt).x_filt);
        data_baseline.(fileNameWithoutExt).sigma_y=std(data_baseline.(fileNameWithoutExt).y_filt);
        data_baseline.(fileNameWithoutExt).mean_x=mean(data_baseline.(fileNameWithoutExt).x_filt);
        data_baseline.(fileNameWithoutExt).mean_y=mean(data_baseline.(fileNameWithoutExt).y_filt);
        data_baseline.(fileNameWithoutExt).rho=corr(data_baseline.(fileNameWithoutExt).x_filt,data_baseline.(fileNameWithoutExt).y_filt);
        data_baseline.(fileNameWithoutExt).BCEA=2*pi*k*data_baseline.(fileNameWithoutExt).sigma_x*data_baseline.(fileNameWithoutExt).sigma_y*sqrt(1-data_baseline.(fileNameWithoutExt).rho^2);
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
        plot(data_baseline.(fileNameWithoutExt).t_clean, data_baseline.(fileNameWithoutExt).theta_dot,'Color', '#1a80bb', 'Linewidth', 2);
        grid on; 
        axis tight; 
        xlabel('Time [s]', 'FontSize', 49);
        ylabel('Angular Velocity [°/s]', 'FontSize', 49);
        set(gca, 'FontSize', 30);
        ylim([0 1200]) 
    end
    jpg_filename = sprintf('%sVelocityBaseline.jpg', fileNameWithoutExt);
    eps_filename = sprintf('%sVelocityBaseline.eps', fileNameWithoutExt);
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
        plot(data_baseline.(fileNameWithoutExt).saccades.GAZE.t, data_baseline.(fileNameWithoutExt).saccades.GAZE.vel, 'Color', '#1a80bb','Linewidth', 2); hold on;
        hold on
        grid on
        plot(data_baseline.(fileNameWithoutExt).saccades.GAZE.t(data_baseline.(fileNameWithoutExt).saccades.SACC.peak_idxs),data_baseline.(fileNameWithoutExt).saccades.SACC.peak_vals,'r.', 'Markersize',15);
        plot(data_baseline.(fileNameWithoutExt).saccades.GAZE.t(data_baseline.(fileNameWithoutExt).saccades.SACC.onsets),data_baseline.(fileNameWithoutExt).saccades.GAZE.vel(data_baseline.(fileNameWithoutExt).saccades.SACC.onsets),'b.', 'Markersize', 15);
        plot(data_baseline.(fileNameWithoutExt).saccades.GAZE.t(data_baseline.(fileNameWithoutExt).saccades.SACC.offsets),data_baseline.(fileNameWithoutExt).saccades.GAZE.vel(data_baseline.(fileNameWithoutExt).saccades.SACC.offsets),'k.', 'Markersize',15); hold off;
        if ~isnan(data.(fileNameWithoutExt).saccades.SACC.PT)
            yline(data.(fileNameWithoutExt).saccades.SACC.PT, 'k--', 'Linewidth', 2)
        end
        lgd=legend('Velocity','Peak','Onset','Offset','Threshold');
        lgd.NumColumns = 3;
        xlim([min(data_baseline.(fileNameWithoutExt).saccades.GAZE.t) max(data_baseline.(fileNameWithoutExt).saccades.GAZE.t)])
        ylim([0 max(data_baseline.(fileNameWithoutExt).saccades.GAZE.vel)+200])
        xlabel('Time [s]', 'FontSize',30);
        ylabel('Angular Velocity [°/s]', 'FontSize',30);
        jpg_filename = sprintf('%sSaccadesBaseline.jpg', (fileNameWithoutExt));
        eps_filename = sprintf('%sSaccadesBaseline.eps', (fileNameWithoutExt));
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

STD_x_table=[];
STD_y_table=[];
MEAN_x_table=[];
MEAN_y_table=[];
RHO_table=[];
BCEA_table=[];
NummSacc_table=[];
subjectIndex = 1; 

for i = 1:length(fileNames) 
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name;     
    [~, fileNameWithoutExt, ~] = fileparts(fullFileName);  
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    if ismember(fullFileName, specificFiles) 

        AMP = data_baseline.(fileNameWithoutExt).saccades.SACC.amplitudes';
        PVAMP = data_baseline.(fileNameWithoutExt).saccades.SACC.peak_vals;
        PVDUR = data_baseline.(fileNameWithoutExt).saccades.SACC.durations';
        FDUR = [NaN;data_baseline.(fileNameWithoutExt).saccades.SACC.gaze_times'];
        BCEA_map=data_baseline.(fileNameWithoutExt).BCEA;
        close all
        featuremap = table(AMP,PVAMP,PVDUR);
        featuremap_duration=table(FDUR);
        featuremap = table(AMP,PVAMP,PVDUR);
        featuremap_duration=table(FDUR);
        csvFilePath = [(fileNameWithoutExt), '_BaselineParameters.csv'];
        writetable(featuremap,csvFilePath,'Delimiter',',');
        csvFilePath_duration = [(fileNameWithoutExt), '_BaselineDuration.csv'];
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
        STD_x=data_baseline.(fileNameWithoutExt).sigma_x;
        STD_y=data_baseline.(fileNameWithoutExt).sigma_y;
        MEAN_x=data_baseline.(fileNameWithoutExt).mean_x;
        MEAN_y=data_baseline.(fileNameWithoutExt).mean_y;
        RHO=data_baseline.(fileNameWithoutExt).rho;
        BCEA=data_baseline.(fileNameWithoutExt).BCEA;
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
        NumSacc_table(subjectIndex)=length(data.(fileNameWithoutExt).saccades.SACC.amplitudes);

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
    NumSacc_table, ...
    'VariableNames', {'SubjectID', 'MeanSaccAmp', 'StdSaccAmp', 'MedianSaccAmp', ...
                      'MeanPeakVelAmp','StdPeakVelAmp','MedianPeakVelAmp', ...
                      'MeanSaccDur','StdSaccDur','MedianSaccDur', ...
                      'MeanFixDur','StdFixDur','MedianFixDur','NumSacc'});
featurescsvFilePath = ['FeaturesBaseline', '.csv'];
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
featurescsvFilePath = ['FeaturesBaseline_BCEA', '.csv'];
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
        time = data_baseline.(fileNameWithoutExt).t_clean; 
        peakTimes = time(data_baseline.(fileNameWithoutExt).saccades.SACC.peak_idxs);  
        startTime = min(time);
        totalTime = max(time);
        windowEdges = startTime:timeWindow:totalTime;  
        saccadesPerWindow = histcounts(peakTimes, windowEdges);

        data_baseline.(fileNameWithoutExt).saccadesPerWindow = saccadesPerWindow;
        data_baseline.(fileNameWithoutExt).SumSaccadesPerWindow = sum(saccadesPerWindow);

        fh = figure(i); 
        fh.WindowState = 'maximized';
        bar(windowEdges(1:end-1), saccadesPerWindow, 'histc');  
        xlabel('Time [s]', 'FontSize', 30);
        ylabel('Number of Saccades', 'FontSize', 30);
        grid on;
        set(gca, 'FontSize', 30); 

        mean_saccadesPerWindow = mean(saccadesPerWindow);
        std_saccadesPerWindow = std(saccadesPerWindow);
        median_saccadesPerWindow = median(saccadesPerWindow);

        data_baseline.(fileNameWithoutExt).mean_saccadesPerWindow = mean_saccadesPerWindow;
        data_baseline.(fileNameWithoutExt).std_saccadesPerWindow = std_saccadesPerWindow;
        data_baseline.(fileNameWithoutExt).median_saccadesPerWindow = median_saccadesPerWindow;

        subjectIDs{end + 1} = fileNameWithoutExt;
        totalSaccadesPerWindow(subjectIndex) = data_baseline.(fileNameWithoutExt).SumSaccadesPerWindow;
        meanSaccadesPerWindow(subjectIndex) = mean_saccadesPerWindow;
        stdSaccadesPerWindow(subjectIndex) = std_saccadesPerWindow;
        medianSaccadesPerWindow(subjectIndex) = median_saccadesPerWindow;

        jpg_filename = sprintf('%s_SaccadesInTimeBaseline.jpg', fileNameWithoutExt);
        eps_filename = sprintf('%s_SaccadesInTimeBaseline.eps', fileNameWithoutExt);
        saveas(gcf, jpg_filename, 'jpg');
        saveas(gcf, eps_filename, 'epsc');

        subjectIndex = subjectIndex + 1;
    end

end

resultTable = table(subjectIDs', totalSaccadesPerWindow', meanSaccadesPerWindow', stdSaccadesPerWindow', medianSaccadesPerWindow','VariableNames', {'SubjectID', 'TotalSaccadesPerWindow', 'MeanSaccadesPerWindow', 'StdSaccadesPerWindow','MedianSaccadesPerWindow'});
saccadescsvFilePath = ['NumSaccadesBaseline', '.csv'];
writetable(resultTable,saccadescsvFilePath,'Delimiter',',');

close all




