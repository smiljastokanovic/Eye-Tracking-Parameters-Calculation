%% Blink analysis – Baseline / Ride / Fog / PostRide
% Smilja – 2025-09

clear all; clc;
SubjectTimestamps;
%% === Settings ===
folderPath = 'C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection';
fileList = dir(fullfile(folderPath, '*txt'));

specificFiles = {'1703_01_gazedata_output.txt', '1703_02_gazedata_output.txt', ...
    '1703_03_gazedata_output.txt', '1703_05_gazedata_output.txt', '1703_06_gazedata_output.txt', ...
    '1703_07_gazedata_output.txt', '1703_08_gazedata_output.txt', '1803_01_gazedata_output.txt', ...
    '1803_02_gazedata_output.txt', '1803_03_gazedata_output.txt', '1803_04_gazedata_output.txt', ...
    '1803_05_gazedata_output.txt', '1903_01_gazedata_output.txt', '1903_02_gazedata_output.txt', ...
    '1903_03_gazedata_output.txt', '1903_05_gazedata_output.txt', '1903_07_gazedata_output.txt', ...
    '1903_08_gazedata_output.txt', '2003_01_gazedata_output.txt', '2003_02_gazedata_output.txt', ...
    '2003_03_gazedata_output.txt', '2003_04_gazedata_output.txt', '2003_06_gazedata_output.txt', ...
    '2003_07_gazedata_output.txt', '2003_08_gazedata_output.txt'};

fs = 100;  % Hz
minBlinkDur_ms = 100;
maxBlinkDur_ms = 400;
minBlinkSep_ms = 100;
maxNaNDuration = 50;

colors = {'#1a80bb', '#800074'};
blinkColor = 'r';

%% === Settings ===
folderPath_blinks='C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Blink Detection';
segFolders = struct( ...
    'Baseline', fullfile(folderPath_blinks,'Baseline'), ...
    'Ride',     fullfile(folderPath_blinks,'Ride'), ...
    'Fog',      fullfile(folderPath_blinks,'Fog'), ...
    'PostRide', fullfile(folderPath_blinks,'PostRide') ...
);

% Make sure folders exist
flds = fieldnames(segFolders);
for f = 1:numel(flds)
    if ~exist(segFolders.(flds{f}),'dir')
        mkdir(segFolders.(flds{f}));
    end
end
segments = {'Baseline','Ride','Fog','PostRide'};
%%
for i = 1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);
    fullFileName = fileList(i).name; [~, fileNameWithoutExt, ~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);
    fileNames{i} = fileNameWithoutExt;
    data_read = readmatrix(filePath);
    if ismember(fullFileName, specificFiles) 
        data.(fileNameWithoutExt).t = data_read(:, 1);
        x_norm = (data_read(:, 2)-min(data_read(:, 2))) / (max(data_read(:, 2)) - min(data_read(:, 2)));
        y_norm = (data_read(:, 3)-min(data_read(:, 3))) / (max(data_read(:, 3)) - min(data_read(:, 3)));
        data.(fileNameWithoutExt).x = x_norm * 1920;
        data.(fileNameWithoutExt).y = y_norm * 1080;
        pupil_left = data_read(:, 13);
        %(data_read(:, 4) - min(data_read(:, 4))) / (max(data_read(:, 4)) - min(data_read(:, 4)));
        pupil_right = data_read(:, 20);
        data.(fileNameWithoutExt).pupilLeft=pupil_left;
        data.(fileNameWithoutExt).pupilRight=pupil_right;
        t = data.(fileNameWithoutExt).t;
        [~, data.(fileNameWithoutExt).StartBaselineIdx] = min(abs(t - data.(fileNameWithoutExt).StartBaseline)); 
        [~, data.(fileNameWithoutExt).EndBaselineIdx] = min(abs(t - data.(fileNameWithoutExt).EndBaseline));
        [~, data.(fileNameWithoutExt).StartRideIdx] = min(abs(t - data.(fileNameWithoutExt).StartRide));
        [~, data.(fileNameWithoutExt).StartFogIdx] = min(abs(t - data.(fileNameWithoutExt).StartFog));
        [~, data.(fileNameWithoutExt).EndFogIdx] = min(abs(t - data.(fileNameWithoutExt).EndFog));
        [~, data.(fileNameWithoutExt).EndRideIdx] = min(abs(t - data.(fileNameWithoutExt).EndRide));
        StartBaselineIdx = data.(fileNameWithoutExt).StartBaselineIdx;
        EndBaselineIdx = data.(fileNameWithoutExt).EndBaselineIdx;
        StartRideIdx = data.(fileNameWithoutExt).StartRideIdx;
        StartFogIdx = data.(fileNameWithoutExt).StartFogIdx;
        EndFogIdx = data.(fileNameWithoutExt).EndFogIdx;
        EndRideIdx = data.(fileNameWithoutExt).EndRideIdx;

        segIdxs = struct( ...
        'Baseline', [StartBaselineIdx, EndBaselineIdx], ...
        'Ride',     [StartRideIdx, StartFogIdx], ...
        'Fog',      [StartFogIdx, EndFogIdx], ...
        'PostRide', [EndFogIdx, EndRideIdx] ...   
    );
        pupilLeft=data.(fileNameWithoutExt).pupilLeft(StartBaselineIdx:EndRideIdx);
        pupilRight=data.(fileNameWithoutExt).pupilRight(StartBaselineIdx:EndRideIdx);
        t=t(StartBaselineIdx:EndRideIdx);
        
        fh_clean = figure('Name',[fileNameWithoutExt ' – Raw Pupil Signals'],'NumberTitle','off'); 
        fh_clean.WindowState = 'maximized';

        % Left pupil
        subplot(2,1,1)
        plot(data.(fileNameWithoutExt).t, data.(fileNameWithoutExt).pupilLeft, 'Color', colors{1}, 'LineWidth',2);
        ylabel({'Left Pupil'; 'Diameter [mm]'}, 'FontSize',30);
        grid on; ylim([0 10]); set(gca,'FontSize',30);
%         title('Left Pupil - Raw Signal', 'FontSize',20);

        % Right pupil
        subplot(2,1,2)
        plot(data.(fileNameWithoutExt).t, data.(fileNameWithoutExt).pupilRight, 'Color', colors{2}, 'LineWidth',2);
        xlabel('Time [s]', 'FontSize',30); 
        ylabel({'Right Pupil'; 'Diameter [mm]'}, 'FontSize',30);
        grid on; ylim([0 10]); set(gca,'FontSize',30);
%         title('Right Pupil - Raw Signal', 'FontSize',20);

        % Optional: Sačuvaj figure
        figPathJPG = fullfile(folderPath_blinks, sprintf('%s_RawPupilSignals.jpg', fileNameWithoutExt));
        figPathEPS = fullfile(folderPath_blinks, sprintf('%s_RawPupilSignals.eps', fileNameWithoutExt));
        saveas(fh_clean, figPathJPG);

        %% ---- Remove long NaN gaps ----
        nanBoth = isnan(pupilLeft) | isnan(pupilRight);
        cc = bwconncomp(nanBoth);
        longNaNs = false(numel(t),1);
        for k = 1:cc.NumObjects
            if numel(cc.PixelIdxList{k}) >= maxNaNDuration
                longNaNs(cc.PixelIdxList{k}) = true;
            end
        end
        keepMask = ~longNaNs;
        pupilLeft  = pupilLeft(keepMask);
        pupilRight = pupilRight(keepMask);
        t_clean    = (0:numel(pupilLeft)-1)/fs;
        data.(fileNameWithoutExt).t_clean=t_clean;
        data.(fileNameWithoutExt).pupilLeft_clean=pupilLeft;
        data.(fileNameWithoutExt).pupilRight_clean=pupilRight;

        %% ---- Blink detection ----
        nanBoth = isnan(pupilLeft) & isnan(pupilRight);
        if any(nanBoth)   % only run if at least one blink candidate exists
            diffMask = diff([0; nanBoth; 0]);
            blink_starts = find(diffMask==1);
            blink_ends   = find(diffMask==-1) - 1;

            % Duration filter
            dur_s = (blink_ends - blink_starts + 1)/fs;
            good = dur_s >= minBlinkDur_ms/1000 & dur_s <= maxBlinkDur_ms/1000;
            blink_starts = blink_starts(good);
            blink_ends   = blink_ends(good);

            % Merge close blinks
            keep_s = []; keep_e = [];
            iB = 1;
            while iB <= numel(blink_starts)
                s = blink_starts(iB);
                e = blink_ends(iB);
                while iB < numel(blink_starts) && (blink_starts(iB+1)-e)/fs*1000 < minBlinkSep_ms
                    iB = iB+1;
                    e = blink_ends(iB);
                end
                keep_s(end+1) = s; 
                keep_e(end+1) = e; 
                iB = iB+1;
            end
            blink_starts = keep_s;
            blink_ends   = keep_e;

        else
            blink_starts = [];
            blink_ends   = [];
        end

%         nanEither = isnan(pupilLeft) & isnan(pupilRight);
%         diffMask = diff([0; nanEither; 0]);
%         blink_starts = find(diffMask==1);
%         blink_ends   = find(diffMask==-1) - 1;
% 
%         % Duration filter
%         dur_s = (blink_ends - blink_starts + 1)/fs;
%         good = dur_s >= minBlinkDur_ms/1000 & dur_s <= maxBlinkDur_ms/1000;
%         blink_starts = blink_starts(good);
%         blink_ends   = blink_ends(good);
% 
%         % Merge close blinks
%         keep_s = []; keep_e = [];
%         iB = 1;
%         while iB <= numel(blink_starts)
%             s = blink_starts(iB);
%             e = blink_ends(iB);
%             while iB < numel(blink_starts) && (blink_starts(iB+1)-e)/fs*1000 < minBlinkSep_ms
%                 iB = iB+1;
%                 e = blink_ends(iB);
%             end
%             keep_s(end+1) = s; 
%             keep_e(end+1) = e; 
%             iB = iB+1;
%         end
%         blink_starts = keep_s;
%         blink_ends   = keep_e;

        %% ---- Plot ----
        fh = figure('Name',[fileNameWithoutExt ' – Pupil Blinks'],'NumberTitle','off'); 
        fh.WindowState='maximized';
        segIdx_raw = [StartBaselineIdx, EndBaselineIdx, ...
                      StartRideIdx, StartFogIdx, EndFogIdx, EndRideIdx];
        segIdx_rel = segIdx_raw - StartBaselineIdx + 1;   % shift so first sample = 1
        validPositions = find(keepMask);      % indices in raw block that remain
        % map each event to the *closest* surviving sample
        N = numel(t_clean);
        mapToClean = @(idx) max(1, min(N, ...
        round(interp1(validPositions, 1:N, idx, 'nearest', 'extrap'))));

        StartBaselineIdx_clean = mapToClean(segIdx_rel(1));
        EndBaselineIdx_clean   = mapToClean(segIdx_rel(2));
        StartRideIdx_clean     = mapToClean(segIdx_rel(3));
        StartFogIdx_clean      = mapToClean(segIdx_rel(4));
        EndFogIdx_clean        = mapToClean(segIdx_rel(5));
        EndRideIdx_clean       = mapToClean(segIdx_rel(6));
%         subplot(2,1,1)
%         plot(t_clean, pupilLeft, 'Color', colors{1}, 'LineWidth',2); hold on;
%         for b = 1:length(blink_starts)
%             startVal = pupilLeft(max(blink_starts(b)-1,1));
%             plot(t(blink_starts(b)), startVal,'ro','MarkerFaceColor','r','MarkerSize',5);
%             idx = blink_starts(b):blink_ends(b);
%             valid_idx = idx(~isnan(pupilLeft(idx)));
%             if ~isempty(valid_idx)
%                 plot(t(blink_ends(b)), pupilLeft(valid_idx(end)),'k*','MarkerFaceColor','m','MarkerSize',5);
%             end
%             xline(t_clean(StartBaselineIdx_clean), '--r', 'Baseline Start');
%             xline(t_clean(EndBaselineIdx_clean), '--k', 'Baseline End');
%             xline(t_clean(StartRideIdx_clean), '--r', 'Ride Start');
%             xline(t_clean(StartFogIdx_clean), '--r', 'Fog Start');
%             xline(t_clean(EndFogIdx_clean), '--k', 'Fog End');
%             xline(t_clean(EndRideIdx_clean), '--k', 'Ride End');
%             xlim([t_clean(StartBaselineIdx_clean), t_clean(EndRideIdx_clean)+10])

%         end
        grid on; ylim([0 10]);
        ylabel({'Left Pupil';'Diameter [mm]'},'FontSize',30);
        set(gca,'FontSize',30);

        %title('Left pupil','FontSize',22); set(gca,'FontSize',20);

        % Right pupil
        subplot(2,1,2)
        plot(t_clean, pupilRight, 'Color', colors{2}, 'LineWidth',2); hold on;
        for b = 1:length(blink_starts)
            startVal = pupilRight(max(blink_starts(b)-1,1));
            plot(t(blink_starts(b)), startVal,'ro','MarkerFaceColor','r','MarkerSize',5);
            idx = blink_starts(b):blink_ends(b);
            valid_idx = idx(~isnan(pupilRight(idx)));
            if ~isempty(valid_idx)
                plot(t(blink_ends(b)), pupilRight(valid_idx(end)),'k*','MarkerFaceColor','k','MarkerSize',5);
            end
%             xline(t_clean(StartBaselineIdx_clean), '--r', 'Baseline Start');
%             xline(t_clean(EndBaselineIdx_clean), '--k', 'Baseline End');
%             xline(t_clean(StartRideIdx_clean), '--r', 'Ride Start');
%             xline(t_clean(StartFogIdx_clean), '--r', 'Fog Start');
%             xline(t_clean(EndFogIdx_clean), '--k', 'Fog End');
%             xline(t_clean(EndRideIdx_clean), '--k', 'Ride End');
%             xlim([t_clean(StartBaselineIdx_clean), t_clean(EndRideIdx_clean)+10])
        end

        grid on; ylim([0 10]);
        xlabel('Time [s]','FontSize',30);
        ylabel({'Right Pupil';'Diameter [mm]'},'FontSize',30);
        set(gca,'FontSize',30);
        Lgnd =  legend({'Pupil','Blink Start','Blink End'},'FontSize',20); 
        Lgnd.Position(1) = -0.1; Lgnd.Position(2) = 0.4;
        title('Right pupil','FontSize',30); set(gca,'FontSize',30);
        data.(fileNameWithoutExt).blink_starts = blink_starts;
        data.(fileNameWithoutExt).blink_ends = blink_ends;
        data.(fileNameWithoutExt).StartBaselineIdx_clean = StartBaselineIdx_clean;
        data.(fileNameWithoutExt).EndBaselineIdx_clean   = EndBaselineIdx_clean;
        data.(fileNameWithoutExt).StartRideIdx_clean     = StartRideIdx_clean;
        data.(fileNameWithoutExt).StartFogIdx_clean      = StartFogIdx_clean;
        data.(fileNameWithoutExt).EndFogIdx_clean        = EndFogIdx_clean;
        data.(fileNameWithoutExt).EndRideIdx_clean       = EndRideIdx_clean;
        data.(fileNameWithoutExt).segIdxs = struct( ...
        'Baseline', [StartBaselineIdx_clean, EndBaselineIdx_clean], ...
        'Ride',     [StartRideIdx_clean,     StartFogIdx_clean], ...
        'Fog',      [StartFogIdx_clean,      EndFogIdx_clean], ...
        'PostRide', [EndFogIdx_clean,        EndRideIdx_clean]);
        
%         saveas(fh, fullfile( folderPath_blinks, sprintf('%s_Blinks_subplot.jpg', fileNameWithoutExt)));
%         saveas(fh, fullfile(folderPath_blinks, sprintf('%s_Blinks_subplot.eps', fileNameWithoutExt)));
        close(fh);
    end
end

close all
%% === Loop over files ===
segments = {'Baseline','Ride','Fog','PostRide'};

% Inicijalizuj mapu sa praznim tabelama (Subject kao cell)
summary_by_seg = containers.Map;
for s = 1:numel(segments)
    summary_by_seg(segments{s}) = table('Size',[0 7], ...
        'VariableTypes', {'cell','double','double','double','double','double','double'}, ...
        'VariableNames', {'Subject','Time_min','NumBlinks','BlinkRate_perMin','MeanDur_ms','StdDur_ms','MedianDur_ms'});
end

% Loop kroz fileList (pretpostavka: fileList, specificFiles, segFolders, colors, blinkColor su definisani)
for i = 1:numel(fileList)
    fullFileName = fileList(i).name;
    [~, fileNameWithoutExt] = fileparts(fullFileName);
    safeFileName = matlab.lang.makeValidName(fileNameWithoutExt);

    if ~ismember(fullFileName, specificFiles)
        continue
    end

    % load iz strukture (pretpostavka da si ranije popunio data.(safeFileName))
    if ~isfield(data, safeFileName)
        warning('No data for %s', safeFileName); continue;
    end
    S = data.(safeFileName);
    t_clean = S.t_clean;
    pupilLeft = S.pupilLeft_clean;
    pupilRight = S.pupilRight_clean;
    blink_starts = S.blink_starts;
    blink_ends = S.blink_ends;
    segIdxs = S.segIdxs;
    Nclean = numel(t_clean);
    fs = 100;

    for s = 1:numel(segments)
        segName = segments{s};
        idxRange = segIdxs.(segName);

        % osiguraj validne indekse
        idxRange(1) = max(1, min(Nclean, idxRange(1)));
        idxRange(2) = max(1, min(Nclean, idxRange(2)));
        if idxRange(2) <= idxRange(1)
            warning('Invalid idxRange for %s %s', safeFileName, segName);
            continue
        end

        % Pozovi blinkStats sa indeksom segmenta (korigovano: idxRange(1), idxRange(2))
        T = blinkStats(t_clean, blink_starts, blink_ends, idxRange(1), idxRange(2), fs, safeFileName);

        % Izvuci osnovne metrike iz T
        if isempty(T)
            numBlinks = 0;
            blink_durations_ms = [];
        else
            numBlinks = height(T);
            blink_durations_ms = T.Duration_ms;
        end
        segment_time_min = (idxRange(2) - idxRange(1) + 1) / fs / 60;  % u minutama
        if segment_time_min == 0
            blink_rate = NaN;
        else
            blink_rate = numBlinks / segment_time_min;
        end

        if isempty(blink_durations_ms)
            meanDur = NaN; stdDur = NaN; medDur = NaN;
        else
            meanDur = mean(blink_durations_ms);
            stdDur  = std(blink_durations_ms);
            medDur  = median(blink_durations_ms);
        end

        % === Ažuriraj summary za segment: add/replace po Subjectu ===
        segTable = summary_by_seg(segName);
        existsIdx = find(strcmp(segTable.Subject, safeFileName));
        newRow = table({safeFileName}, segment_time_min, numBlinks, blink_rate, meanDur, stdDur, medDur, ...
            'VariableNames', {'Subject','Time_min','NumBlinks','BlinkRate_perMin','MeanDur_ms','StdDur_ms','MedianDur_ms'});
        if isempty(existsIdx)
            segTable = [segTable; newRow];
        else
            segTable(existsIdx, :) = newRow; % replace (drži samo jedan red po subjektu)
        end
        summary_by_seg(segName) = segTable;

        % === Sačuvaj pojedinačni blink T (ako nije prazan) ===
        segFolder = segFolders.(segName);
        if ~exist(segFolder,'dir'), mkdir(segFolder); end
        if ~isempty(T)
            writetable(T, fullfile(segFolder, sprintf('%s_%s_Blinks.xlsx', safeFileName, segName)));
        else
            writetable(T, fullfile(segFolder, sprintf('%s_%s_Blinks_empty.xlsx', safeFileName, segName)));
        end

        % === PLOT za taj subject/segment (2 subplots: left/right) ===
        try
            fh = figure('Name',[safeFileName ' – ' segName],'NumberTitle','off');
            fh.WindowState = 'maximized';

            t_seg = t_clean(idxRange(1):idxRange(2));
            pupilLeft_seg  = pupilLeft(idxRange(1):idxRange(2));
            pupilRight_seg = pupilRight(idxRange(1):idxRange(2));

            subplot(2,1,1);
            plot(t_seg, pupilLeft_seg, 'Color', colors{1}, 'LineWidth', 2); hold on;
            ylabel({'Left Pupil'; 'Diameter [mm]'}, 'FontSize',30);
            set(gca,'FontSize',30); grid on; ylim([0 10]);

            yl = ylim(gca);
            yBlink = yl(1) + 0.5;   % place a bit above the bottom

            nanMaskLeft = isnan(pupilLeft_seg) & isnan(pupilRight_seg); % true only when both are NaN
            nanIdx = find(nanMaskLeft);

            if ~isempty(nanIdx)
                cc = bwconncomp(nanMaskLeft);
                for k = 1:cc.NumObjects
                    segIdx = cc.PixelIdxList{k};
                    xBlink = [t_seg(segIdx(1)), t_seg(segIdx(end))];
                    line(xBlink, [yBlink yBlink], 'Color','r','LineWidth',4); % thicker red line
                end
            end

            xlim([t_clean(idxRange(1)), t_clean(idxRange(2))]);

            % --- Right pupil ---
            subplot(2,1,2);
            plot(t_seg, pupilRight_seg, 'Color', colors{2}, 'LineWidth', 2); hold on;
            xlabel('Time [s]','FontSize',30);
            ylabel({'Right Pupil'; 'Diameter [mm]'}, 'FontSize',30);
            set(gca,'FontSize',30); grid on; ylim([0 10]);

            yl = ylim(gca);
            yBlink = yl(1) + 0.5;

            nanMaskRight = isnan(pupilLeft_seg) & isnan(pupilRight_seg);
            nanIdx = find(nanMaskRight);

            if ~isempty(nanIdx)
                cc = bwconncomp(nanMaskRight);
                for k = 1:cc.NumObjects
                    segIdx = cc.PixelIdxList{k};
                    xBlink = [t_seg(segIdx(1)), t_seg(segIdx(end))];
                    line(xBlink, [yBlink yBlink], 'Color','r','LineWidth',4);
                end
            end
    

            xlim([t_clean(idxRange(1)), t_clean(idxRange(2))]);

            Lgnd =  legend({'Pupil','Blink'},'FontSize',18); 
            Lgnd.Position(1) = -0.05; Lgnd.Position(2) = 0.4;
            % Save figures
            figPathJPG = fullfile(segFolder, sprintf('%s_%s_Blinks.jpg', safeFileName, segName));
            figPathEPS = fullfile(segFolder, sprintf('%s_%s_Blinks.eps', safeFileName, segName));
            drawnow;
            saveas(fh, figPathJPG);
            saveas(fh, figPathEPS);
            close(fh);
        catch ME
            warning('Plot failed for %s %s: %s', safeFileName, segName, ME.message);
            if exist('fh','var') && isvalid(fh), close(fh); end
        end
        
    end % segments
end % files

%%
keysSeg = keys(summary_by_seg);
for k = 1:numel(keysSeg)
    segName = keysSeg{k};
    segTable = summary_by_seg(segName);
    if ~isempty(segTable)
        writetable(segTable, fullfile(segFolders.(segName), ['blink_summary_all_subjects_' segName '.csv']));
        disp(['Saved summary for ' segName ' (n=' num2str(height(segTable)) ')']);
    end
end
%%
for i = 1:3%numel(fileList)
    fullFileName = fileList(i).name;
    [~, fileNameWithoutExt] = fileparts(fullFileName);
    safeFileName = matlab.lang.makeValidName(fileNameWithoutExt);

    if ~ismember(fullFileName, specificFiles)
        continue
    end

    if ~isfield(data, safeFileName)
        warning('No data for %s', safeFileName); 
        continue;
    end

    % --- Load subject data ---
    S = data.(safeFileName);
    t_clean = S.t_clean;
    pupilLeft = S.pupilLeft_clean;
    pupilRight = S.pupilRight_clean;
    blink_starts = S.blink_starts;
    blink_ends   = S.blink_ends;
    segIdxs = S.segIdxs;
    Nclean = numel(t_clean);
    fs = 100;

    for s = 1:numel(segments)
        segName = segments{s};
        idxRange = segIdxs.(segName);
        idxRange(1) = max(1, min(Nclean, idxRange(1)));
        idxRange(2) = max(1, min(Nclean, idxRange(2)));
        if idxRange(2) <= idxRange(1)
            warning('Invalid idxRange for %s %s', safeFileName, segName);
            continue
        end

        % --- Extract segment ---
        t_seg = t_clean(idxRange(1):idxRange(2));
        pupilLeft_seg  = pupilLeft(idxRange(1):idxRange(2));
        pupilRight_seg = pupilRight(idxRange(1):idxRange(2));

        % --- Blinks that occur within this segment ---
        inSegment = (blink_starts >= idxRange(1) & blink_starts <= idxRange(2));
        blinkStartsSeg = blink_starts(inSegment);
        blinkEndsSeg   = blink_ends(inSegment);

        % convert to segment-relative indices
        blinkStartsRel = blinkStartsSeg - idxRange(1) + 1;
        blinkEndsRel   = blinkEndsSeg - idxRange(1) + 1;

                % --- Plot ---
        try
            fh = figure('Name',[safeFileName ' – ' segName],'NumberTitle','off');
            fh.WindowState = 'maximized';

            t_seg = t_clean(idxRange(1):idxRange(2));
            pupilLeft_seg  = pupilLeft(idxRange(1):idxRange(2));
            pupilRight_seg = pupilRight(idxRange(1):idxRange(2));

            % --- Detect blink (NaN) segments common to both pupils ---
            nanMaskBoth = isnan(pupilLeft_seg) & isnan(pupilRight_seg);
            cc = bwconncomp(nanMaskBoth);

            blinkStartIdx = [];
            blinkEndIdx   = [];

            for k = 1:cc.NumObjects
                segIdx = cc.PixelIdxList{k};
                blinkStartIdx(end+1) = segIdx(1);
                blinkEndIdx(end+1)   = segIdx(end);
            end

            % --- Left pupil ---
            subplot(2,1,1);
            plot(t_seg, pupilLeft_seg, 'Color', colors{1}, 'LineWidth', 2); hold on;
            ylabel({'Diameter'; '[mm]'}, 'FontSize',38);
            title('Left Pupil', 'FontSize',38)
            set(gca,'FontSize',38); grid on; ylim([0 10]);xlim([0 400])
            % Plot blink edges as red stars on signal
            if ~isempty(blinkStartIdx)
                validStart = blinkStartIdx(blinkStartIdx <= numel(pupilLeft_seg));
                validEnd   = blinkEndIdx(blinkEndIdx <= numel(pupilLeft_seg));

                plot(t_seg(validStart), pupilLeft_seg(max(validStart-1,1)), 'r*', 'MarkerSize', 5, 'LineWidth', 1.5);
                plot(t_seg(validEnd), pupilLeft_seg(min(validEnd+1,numel(pupilLeft_seg))), 'k*', 'MarkerSize', 5, 'LineWidth', 1.5);
            end

            %xlim([t_clean(idxRange(1)), t_clean(idxRange(2))]);

            % --- Right pupil ---
            subplot(2,1,2);
            plot(t_seg, pupilRight_seg, 'Color', colors{1}, 'LineWidth', 2); hold on;
            xlabel('Time [s]','FontSize',38);
            ylabel({'Diameter'; '[mm]'}, 'FontSize',38);
            title('Right Pupil', 'FontSize',38)
            set(gca,'FontSize',38); grid on; ylim([0 10]);xlim([0 400])

            % Plot same blink edges on right signal
            if ~isempty(blinkStartIdx)
                validStart = blinkStartIdx(blinkStartIdx <= numel(pupilRight_seg));
                validEnd   = blinkEndIdx(blinkEndIdx <= numel(pupilRight_seg));

                plot(t_seg(validStart), pupilRight_seg(max(validStart-1,1)), 'r*', 'MarkerSize', 5, 'LineWidth', 1.5);
                plot(t_seg(validEnd), pupilRight_seg(min(validEnd+1,numel(pupilRight_seg))), 'k*', 'MarkerSize', 5, 'LineWidth', 1.5);
            end

            %xlim([t_clean(idxRange(1)), t_clean(idxRange(2))]);

            Lgnd =  legend({'Pupil','Blink Start', 'Blink End'},'FontSize',20); 
            Lgnd.Position(1) = -0.1; Lgnd.Position(2) = 0.4;
            drawnow;
            segFolder = segFolders.(segName);

            % --- Save figures ---
            figPathJPG = fullfile(segFolder, sprintf('%s_%s_BlinksDot2.jpg', safeFileName, segName));
            figPathEPS = fullfile(segFolder, sprintf('%s_%s_BlinksDot2.eps', safeFileName, segName));
            saveas(fh, figPathJPG);
            saveas(fh, figPathEPS);
%             close(fh);
            fh2 = figure('Name',[safeFileName ' – ' segName],'NumberTitle','off');
            fh2.WindowState = 'maximized';
            plot(t_seg, pupilLeft_seg, 'Color', colors{1}, 'LineWidth', 2); hold on;
            ylabel({'Diameter [mm]'}, 'FontSize',45);
            xlabel({'Time [s]'}, 'FontSize',45);

%             title('Left Pupil', 'FontSize',38)
            set(gca,'FontSize',45); grid on; ylim([1 7]);xlim([0 200])
            if ~isempty(blinkStartIdx)
                validStart = blinkStartIdx(blinkStartIdx <= numel(pupilLeft_seg));
                validEnd   = blinkEndIdx(blinkEndIdx <= numel(pupilLeft_seg));

                plot(t_seg(validStart), pupilLeft_seg(max(validStart-1,1)), 'r*', 'MarkerSize', 5, 'LineWidth', 1.5);
                plot(t_seg(validEnd), pupilLeft_seg(min(validEnd+1,numel(pupilLeft_seg))), 'k*', 'MarkerSize', 5, 'LineWidth', 1.5);
            end
            Lgnd =  legend({'Pupil','Blink Start', 'Blink End'},'FontSize',24); 
%             Lgnd.Position(1) = -0.1; Lgnd.Position(2) = 0.4;
%             drawnow;
            segFolder = segFolders.(segName);
            figPathJPG = fullfile(segFolder, sprintf('%s_%s_BlinksDot3.jpg', safeFileName, segName));
            figPathEPS = fullfile(segFolder, sprintf('%s_%s_BlinksDot3.eps', safeFileName, segName));
            saveas(fh2, figPathJPG);
            saveas(fh2, figPathEPS);
            % Plot blink edges as red stars on signal

        catch ME
            warning('Plot failed for %s %s: %s', safeFileName, segName, ME.message);
            if exist('fh','var') && isvalid(fh), close(fh); end
        end
    end
end % files


