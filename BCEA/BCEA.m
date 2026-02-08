%% BCEA Baseline
%% Frodo project
% Smilja Stokanovic
% May, 2025
close all;
clear all;
clc;
SubjectTimestamps;

folderPath='C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection';
fileList=dir(fullfile(folderPath, '*txt'));
fs = 100; %Sampling frequency
k=3;
fileNames=cell(1,length(fileList));
specificFiles = { '1703_01_gazedata_output.txt', '1703_02_gazedata_output.txt', ...
                     '1703_03_gazedata_output.txt','1703_05_gazedata_output.txt', '1703_06_gazedata_output.txt', ...
                     '1703_07_gazedata_output.txt', '1703_08_gazedata_output.txt', '1803_01_gazedata_output.txt', '1803_02_gazedata_output.txt', ...
                     '1803_03_gazedata_output.txt', '1803_04_gazedata_output.txt', '1803_05_gazedata_output.txt', '1903_01_gazedata_output.txt', ...
                     '1903_02_gazedata_output.txt','1903_03_gazedata_output.txt','1903_05_gazedata_output.txt',...
                     '1903_07_gazedata_output.txt','1903_07_gazedata_output.txt','1903_08_gazedata_output.txt','2003_01_gazedata_output.txt',...
                     '2003_02_gazedata_output.txt','2003_03_gazedata_output.txt','2003_04_gazedata_output.txt','2003_06_gazedata_output.txt',...
                     '2003_07_gazedata_output.txt','2003_08_gazedata_output.txt'};
%%
fi_1=95/1920;
fi_2=63/1080;

for i = 1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name;  
    [~, fileNameWithoutExt, ~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    fileNames{i} = fileNameWithoutExt;
    data_read = readmatrix(filePath);
    if ismember(fullFileName, specificFiles)
        data.(fileNameWithoutExt).t = data_read(:, 1); 
        x_norm = (data_read(:, 2)-min(data_read(:, 2)))/(max(data_read(:, 2))-min(data_read(:, 2))); %normalize data
        y_norm = (data_read(:, 3)-min(data_read(:, 3)))/(max(data_read(:, 3))-min(data_read(:, 3)));
        data.(fileNameWithoutExt).x = x_norm*1920;
        data.(fileNameWithoutExt).y = y_norm*1080;
        
        t = data.(fileNameWithoutExt).t;  % already in seconds

        [~, data.(fileNameWithoutExt).StartBaselineIdx] = min(abs(t - data.(fileNameWithoutExt).StartBaseline));
        [~, data.(fileNameWithoutExt).EndBaselineIdx]   = min(abs(t - data.(fileNameWithoutExt).EndBaseline));
        [~, data.(fileNameWithoutExt).StartRideIdx]     = min(abs(t - data.(fileNameWithoutExt).StartRide));
        [~, data.(fileNameWithoutExt).EndRideIdx]       = min(abs(t - data.(fileNameWithoutExt).EndRide));
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
        x = data.(fileNameWithoutExt).x(data.(fileNameWithoutExt).StartBaselineIdx:data.(fileNameWithoutExt).EndBaselineIdx);
        y = data.(fileNameWithoutExt).y(data.(fileNameWithoutExt).StartBaselineIdx:data.(fileNameWithoutExt).EndBaselineIdx);
        t = data.(fileNameWithoutExt).t(data.(fileNameWithoutExt).StartBaselineIdx:data.(fileNameWithoutExt).EndBaselineIdx);
        data_baseline.(fileNameWithoutExt).x_baseline = x;
        data_baseline.(fileNameWithoutExt).y_baseline = y;
        data_baseline.(fileNameWithoutExt).t_baseline = t;
        maxNaNDuration = 0.00001 * fs;  % s cutoff for NaN
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
        data.(fileNameWithoutExt).x_baseline=data_baseline.(fileNameWithoutExt).x_filt;
        data.(fileNameWithoutExt).y_baseline=data_baseline.(fileNameWithoutExt).y_filt;
    end
end

%%
for i=1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);
    if ismember(fullFileName, specificFiles)
        x = data.(fileNameWithoutExt).x_baseline;  
        y = data.(fileNameWithoutExt).y_baseline;
        k=3;
        data.(fileNameWithoutExt).sigma_x_baseline=std(x);
        data.(fileNameWithoutExt).sigma_y_baseline=std(y);
        data.(fileNameWithoutExt).mean_x_baseline=mean(x);
        data.(fileNameWithoutExt).mean_y_baseline=mean(y);
        data.(fileNameWithoutExt).rho_baseline=corr(x,y);
        data.(fileNameWithoutExt).BCEA_baseline=2*pi*k*data.(fileNameWithoutExt).sigma_x_baseline*data.(fileNameWithoutExt).sigma_y_baseline*sqrt(1-data.(fileNameWithoutExt).rho_baseline^2);
        data.(fileNameWithoutExt).cov_matrix = cov(x, y);
        [data.(fileNameWithoutExt).eig_vec, data.(fileNameWithoutExt).eig_val] = eig(data.(fileNameWithoutExt).cov_matrix);
        [data.(fileNameWithoutExt).eig_val_sorted, data.(fileNameWithoutExt).idx] = sort(diag(data.(fileNameWithoutExt).eig_val), 'descend');
        data.(fileNameWithoutExt).eig_vec_sorted = data.(fileNameWithoutExt).eig_vec(:, data.(fileNameWithoutExt).idx);
        
        data.(fileNameWithoutExt).sigma_H = sqrt(data.(fileNameWithoutExt).eig_val_sorted(1)); % STD along the major axis
        data.(fileNameWithoutExt).sigma_V = sqrt(data.(fileNameWithoutExt).eig_val_sorted(2)); % STD along the minor a
        
        data.(fileNameWithoutExt).theta = linspace(0, 2*pi, 100);
        data.(fileNameWithoutExt).ellipse_x = k * sqrt(data.(fileNameWithoutExt).eig_val(1,1)) * cos(data.(fileNameWithoutExt).theta);
        data.(fileNameWithoutExt).ellipse_y = k * sqrt(data.(fileNameWithoutExt).eig_val(2,2)) * sin(data.(fileNameWithoutExt).theta);
        
        data.(fileNameWithoutExt).R = data.(fileNameWithoutExt).eig_vec;  %ispraviti % Rotation matrix from eigenvectors
        data.(fileNameWithoutExt).ellipse_points = data.(fileNameWithoutExt).R * [data.(fileNameWithoutExt).ellipse_x; data.(fileNameWithoutExt).ellipse_y];

        data.(fileNameWithoutExt).ellipse_x = data.(fileNameWithoutExt).ellipse_points(1,:) + data.(fileNameWithoutExt).mean_x_baseline;
        data.(fileNameWithoutExt).ellipse_y = data.(fileNameWithoutExt).ellipse_points(2,:) + data.(fileNameWithoutExt).mean_y_baseline;
        data.(fileNameWithoutExt).major_axis = k * sqrt(data.(fileNameWithoutExt).eig_val(1,1)) * data.(fileNameWithoutExt).eig_vec(:,1);
        data.(fileNameWithoutExt).minor_axis = k * sqrt(data.(fileNameWithoutExt).eig_val(2,2)) * data.(fileNameWithoutExt).eig_vec(:,2);

        x_guzik = data.(fileNameWithoutExt).x_baseline - data.(fileNameWithoutExt).mean_x_baseline;
        y_guzik = data.(fileNameWithoutExt).y_baseline - data.(fileNameWithoutExt).mean_y_baseline;
        xy = [x_guzik(:), y_guzik(:)]'; 

        proj_major = data.(fileNameWithoutExt).major_axis' * xy;
        proj_minor = data.(fileNameWithoutExt).minor_axis' * xy; 

        std_parallel = std(proj_major);
        std_perpendicular = std(proj_minor);

        guziks_index = std_parallel / std_perpendicular;
        proj_perp = data.(fileNameWithoutExt).minor_axis' * xy;  % ispraviti

        MSE_major_axis = mean(proj_perp .^ 2);

        data_section.(fileNameWithoutExt).guziksIndex = guziks_index;
        data_section.(fileNameWithoutExt).MSE_major_axis = MSE_major_axis;
        % ===== INPUT: fixation data ====================================
        %% === PRL Detection with KDE + EM ===
        % Inputs: x, y = fixation coordinates (vectors)
        % fileNameWithoutExt = string with dataset name

        % --------- SETTINGS ----------
        maxK        = 6;       % maximum number of PRLs
        gridSize    = 50;      % KDE grid
        numRestarts = 5;       % EM random starts
        reg         = 1e-6;    % regularisation for Sigma
        maxIter     = 200;
        tol         = 1e-4;
        bcea_k      = 3;       % 95% ellipse constant

        %% --------- PREPARE DATA -------
        x = x(:);
        y = y(:);
        X = [x y];
        n = size(X,1);

        %% === 1) KDE + contour plot ===========================================
        bw  = [std(x) std(y)]/2;           % Bowman–Foster rule-of-thumb
        xg  = linspace(min(x), max(x), gridSize);
        yg  = linspace(min(y), max(y), gridSize);
        [Xg, Yg] = meshgrid(xg, yg);

        dens = mvksdensity(X, [Xg(:) Yg(:)], 'Bandwidth', bw);
        dens = reshape(dens, gridSize, gridSize);

        % --- Detect peaks on density surface
        peakMask = imregionalmax(dens);
        [yidx, xidx] = find(peakMask);
        peakPos = [xg(xidx)', yg(yidx)'];
        if size(peakPos,1) > maxK
            peakPos = peakPos(1:maxK,:); % keep first maxK
        end

        %% === 2) Fit GMM with EM for K = 1:maxK, choose BIC ===================
        bestBIC   = inf;
        bestModel = struct();

        for K = 1:min(maxK, size(peakPos,1))
            bestLL_K = -inf; bestParams = struct();
            for r = 1:numRestarts
                % initialise from first K peaks + jitter
                mu = peakPos(1:K,:) + 0.05*randn(K,2);
                Sigma = repmat(cov(X)+reg*eye(2),1,1,K);
                pi_k = ones(1,K)/K;

                L_old = -inf;
                for it = 1:maxIter
                    % --- E step
                    resp = zeros(n,K);
                    for j = 1:K
                        resp(:,j) = pi_k(j)*mvnpdf(X,mu(j,:),Sigma(:,:,j));
                    end
                    denom = sum(resp,2)+eps;
                    resp = resp ./ denom;

                    % --- M step
                    Nk = sum(resp,1);
                    for j = 1:K
                        mu(j,:) = (resp(:,j)'*X)/Nk(j);
                        diff = X - mu(j,:);
                        Sigma(:,:,j) = (resp(:,j).*diff)'*diff/Nk(j) + reg*eye(2);
                    end
                    pi_k = Nk/n;
                    L = sum(log(denom));
                    if abs(L-L_old) < tol, break; end
                    L_old = L;
                end

                if L > bestLL_K
                    bestLL_K = L;
                    bestParams.mu = mu;
                    bestParams.Sigma = Sigma;
                    bestParams.pi = pi_k;
                    bestParams.LL = L;
                end
            end

            % --- Compute BIC
            nParams = K*(2 + 3); % mean(2) + cov(3) per comp
            BIC = -2*bestParams.LL + nParams*log(n);

            if BIC < bestBIC
                bestBIC = BIC;
                bestModel = bestParams;
                bestK = K;
            end
        end

        %% === 3) Merge overlapping components =================================
        alpha95    = chi2inv(0.95,2);  % 95% ellipse
        minDist    = 30;               % px, distance threshold
        overlapThr = 0.4;              % 40% overlap

        K = bestK;
        merged = false(K,1);

        for i = 1:K
            if merged(i), continue; end
            for j = i+1:K
                if merged(j), continue; end

                d = norm(bestModel.mu(i,:) - bestModel.mu(j,:));
                ov = ellipseOverlap(bestModel.mu(i,:), bestModel.Sigma(:,:,i), ...
                                    bestModel.mu(j,:), bestModel.Sigma(:,:,j), alpha95);

                if (d < minDist) || (ov > overlapThr)
                    % --- merge j into i ---
                    w_i = bestModel.pi(i); w_j = bestModel.pi(j);
                    w_tot = w_i + w_j;

                    new_mu = (w_i*bestModel.mu(i,:) + w_j*bestModel.mu(j,:)) / w_tot;
                    diff_i = bestModel.mu(i,:) - new_mu;
                    diff_j = bestModel.mu(j,:) - new_mu;
                    new_S  = (w_i*(bestModel.Sigma(:,:,i)+diff_i'*diff_i) + ...
                              w_j*(bestModel.Sigma(:,:,j)+diff_j'*diff_j)) / w_tot;

                    bestModel.mu(i,:)      = new_mu;
                    bestModel.Sigma(:,:,i) = new_S;
                    bestModel.pi(i)        = w_tot;

                    merged(j) = true;
                end
            end
        end

        % Keep only non-merged
        keep = ~merged;
        bestModel.mu    = bestModel.mu(keep,:);
        bestModel.Sigma = bestModel.Sigma(:,:,keep);
        bestModel.pi    = bestModel.pi(keep);
        K = sum(keep);

        %% === 4) BCEA for each PRL ============================================
        BCEA = zeros(1,K);
        for j = 1:K
            S  = bestModel.Sigma(:,:,j);
            sx = sqrt(S(1,1));
            sy = sqrt(S(2,2));
            rho = S(1,2)/(sx*sy + eps);
            BCEA(j) = 2*pi*bcea_k*sx*sy*sqrt(max(0,1-rho^2));
        end
        %% === 5) Plot ============================================
        % --- Create maximized figure and axes
        fh = figure;
        fh.WindowState = 'maximized';
        ax = axes(fh);
        hold(ax,'on'); grid(ax,'on');

        colors = lines(K);
        scatterColors = colors(1:K,:);

        hFixations = scatter(ax, X(:,1), X(:,2), 8, 'k', 'filled');
        hContour = [];
        if exist('Xg','var') && exist('Yg','var') && exist('dens','var')
            hContour = contour(ax, Xg, Yg, dens, 'LineWidth',1.2, 'LineColor','#1a80bb');
        end

        hScatter = scatter(ax, bestModel.mu(:,1), bestModel.mu(:,2), 80, scatterColors, 'filled', 'MarkerEdgeColor','k');

        hEllipse = gobjects(K,1);
        for j = 1:K
            [V,D] = eig(bestModel.Sigma(:,:,j));
            t = linspace(0,2*pi,100);
            a = sqrt(bcea_k) * sqrt(D(1,1));
            b = sqrt(bcea_k) * sqrt(D(2,2));
            ellipse = (V*[a*cos(t); b*sin(t)])' + bestModel.mu(j,:);
            hEllipse(j) = plot(ax, ellipse(:,1), ellipse(:,2), 'Color', colors(j,:), 'LineWidth',1.5);
        end

        legend('Fixations','KDE contours','PRL ellipses');
        xlim(ax,[0 2000]); ylim(ax,[0 1100]); axis(ax,'equal');
        axis equal
        xlabel(ax,'X'); ylabel(ax,'Y');
        title(ax,'PRL detection');

        %% === 6) Save outputs =================================================
        outFolder = fullfile(pwd, 'PRL');
        if ~exist(outFolder,'dir')
            mkdir(outFolder);
        end

        % Save figure as PNG
        figName = sprintf('PRL_%s_bestK%d.png', fileNameWithoutExt, K);
        saveas(gcf, fullfile(outFolder, figName));

        % Optional: Save as PDF and FIG
        saveas(gcf, fullfile(outFolder, sprintf('PRL_%s_bestK%d.pdf', fileNameWithoutExt, K)));
        savefig(fullfile(outFolder, sprintf('PRL_%s_bestK%d.fig', fileNameWithoutExt, K)));

        % Save parameters
        data.(fileNameWithoutExt).numPRLs   = K;
        data.(fileNameWithoutExt).mu        = bestModel.mu;
        data.(fileNameWithoutExt).Sigma     = bestModel.Sigma;
        data.(fileNameWithoutExt).pi        = bestModel.pi;
        data.(fileNameWithoutExt).BCEA      = BCEA;
        data.(fileNameWithoutExt).LL        = bestModel.LL;
        data.(fileNameWithoutExt).BIC       = bestBIC;
        results.numPRLs   = K;
        results.mu        = bestModel.mu;
        results.Sigma     = bestModel.Sigma;
        results.pi        = bestModel.pi;
        results.BCEA      = BCEA;
        results.LL        = bestModel.LL;
        results.BIC       = bestBIC;
        save(fullfile(outFolder, sprintf('PRL_%s.mat', fileNameWithoutExt)), 'results');
        close all
    end
end

%%
for i=1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt);
    if ismember(fullFileName, specificFiles)
        x = data.(fileNameWithoutExt).x_baseline(:);  
        y = data.(fileNameWithoutExt).y_baseline(:);

        x = x(~isnan(x));
        y = y(~isnan(y));
        m = 2;
        win_size = 1000;
        step = 500;
        numWinsX = floor((length(x) - win_size) / step) + 1;
        numWinsY = floor((length(y) - win_size) / step) + 1;
        sampen_vals_x = NaN(1, numWinsX); 
        r_vals_x = NaN(1, numWinsX);
        sampen_vals_y = NaN(1, numWinsY);
        r_vals_y = NaN(1, numWinsY);
        for winIdx = 1:numWinsX
            idx = (winIdx - 1) * step + 1;
            segment = x(idx:idx + win_size - 1);
            r = 0.2 * std(segment);
            try
                sampen_vals_x(winIdx) = sampen(segment, m, r);
            catch
                sampen_vals_x(winIdx) = NaN;
            end
            r_vals_x(winIdx) = r;
         end

         for winIdx = 1:numWinsY
            idx = (winIdx - 1) * step + 1;
            segment = y(idx:idx + win_size - 1);
            r = 0.2 * std(segment);
            try
                sampen_vals_y(winIdx) = sampen(segment, m, r);
            catch
                sampen_vals_y(winIdx) = NaN;
            end
            r_vals_y(winIdx) = r;
        end

        data.(fileNameWithoutExt).SampEntX_all = sampen_vals_x;
        data.(fileNameWithoutExt).SampEntX_mean = mean(sampen_vals_x, 'omitnan'); 
        data.(fileNameWithoutExt).AppEntX=approximateEntropy(data.(fileNameWithoutExt).x_baseline);
        data.(fileNameWithoutExt).SampEntY_all = sampen_vals_y;
        data.(fileNameWithoutExt).SampEntY_mean = mean(sampen_vals_y, 'omitnan'); 
        data.(fileNameWithoutExt).AppEntY=approximateEntropy(data.(fileNameWithoutExt).y_baseline);
%       data.(fileNameWithoutExt).SampEntVel=sampen(data.(fileNameWithoutExt).x_baseline,2,0.2 * std(data.(fileNameWithoutExt).x_baseline));
%       data.(fileNameWithoutExt).AppEntVel=approximateEntropy(data.(fileNameWithoutExt).x_baseline);
    
    end
end


%%
for i = 1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    if ismember(fullFileName, specificFiles) 
        k=3;
        fh = figure(i);
        fh.WindowState = 'maximized';

        subplot(1, 3, 1);
        scatter(data.(fileNameWithoutExt).x_baseline, data.(fileNameWithoutExt).y_baseline, 'k.');
        grid on;
        xlabel({'X decentration'; '(min arc)'});
        ylabel('Y decentration (min arc)');
        set(gca, 'FontSize', 30);
        xlim([0, 2000]);  
        ylim([0, 1100]); 

        subplot(1, 3, 2); 
        scatter(data.(fileNameWithoutExt).x_baseline, data.(fileNameWithoutExt).y_baseline, 'k.');
        hold on;
        grid on;
        mu_x=data.(fileNameWithoutExt).mean_x_baseline;
        mu_y=data.(fileNameWithoutExt).mean_y_baseline;

        plot(data.(fileNameWithoutExt).ellipse_x, data.(fileNameWithoutExt).ellipse_y, 'Color','#800074', 'LineWidth', 2); % BCEA ellipse

        major_axis = data.(fileNameWithoutExt).major_axis;
        minor_axis= data.(fileNameWithoutExt).minor_axis;

        xlabel({'X decentration'; '(min arc)'});
%         ylabel('Y decentration (min arc)');
        set(gca, 'FontSize', 30);
        xlim([0, 2000]);  
        ylim([0, 1100]);

        subplot(1, 3, 3); 
        x = data.(fileNameWithoutExt).x_baseline;
        y = data.(fileNameWithoutExt).y_baseline;
        n = length(x); 
        sigma_x_hat = std(x);
        sigma_y_hat = std(y);

        h_x_silverman = sigma_x_hat * n^(-1/6);
        h_y_silverman = sigma_y_hat * n^(-1/6);
        h_x = h_x_silverman * 1.5; 
        h_y = h_y_silverman * 1.5; 
        min_x = min(x); max_x = max(x);
        min_y = min(y); max_y = max(y);

        margin_x = (max_x - min_x) * 0.05;
        margin_y = (max_y - min_y) * 0.05;

        plot_min_x = min_x - margin_x;
        plot_max_x = max_x + margin_x;
        plot_min_y = min_y - margin_y;
        plot_max_y = max_y + margin_y;
        num_grid_points = 50; 
        [X_grid, Y_grid] = meshgrid(linspace(min_x, max_x, num_grid_points), ...
                                   linspace(min_y, max_y, num_grid_points));

        Z_density_manual = zeros(size(X_grid));
        kernel_function = @(u, v) (1/(2*pi)) * exp(-1/2 * (u.^2 + v.^2));
        for j = 1:num_grid_points
            for k = 1:num_grid_points
                current_x = X_grid(j, k);
                current_y = Y_grid(j, k);

                u = (x-current_x)/h_x;
                v = (y-current_y)/h_y;

                sum_kernel_contributions = sum(kernel_function(u, v));

                Z_density_manual(j, k) = 1/(n*h_x * h_y) * sum_kernel_contributions;
            end
        end
        Z_density_manual = Z_density_manual / sum(Z_density_manual(:));
        Z_density_manual_log = log10(Z_density_manual + 1); 
        num_contour_levels = 350; 

        contour(X_grid, Y_grid, Z_density_manual_log, num_contour_levels, 'k');

    end
    jpg_filename = sprintf('%sBCEABaseline.jpg', (fileNameWithoutExt));
    eps_filename = sprintf('%sBCEABaseline.eps', (fileNameWithoutExt));
    saveas(gcf, jpg_filename, 'jpg');
    saveas(gcf, eps_filename, 'epsc');
end
close all
%%

for i = 1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    if ismember(fullFileName, specificFiles) 

        fh = figure(i);
        fh.WindowState = 'maximized';
        data_density = [data.(fileNameWithoutExt).x_baseline, data.(fileNameWithoutExt).y_baseline];

        [density, ~] = ksdensity(data_density, data_density, 'Bandwidth', []);

        % Normalize density for colormap
        densityNorm = (density - min(density)) / (max(density) - min(density));

        % Plot
        scatter(data.(fileNameWithoutExt).x_baseline, data.(fileNameWithoutExt).y_baseline, 20, densityNorm, 'filled');
        hold on
        grid on
        colormap(jet(256));
        colorbar;
        xlabel('X decentration (min arc)');
        ylabel('Y decentration (min arc)');
        set(gca, 'FontSize', 30);
        xlim([0, 2000]);  
        ylim([0, 1100]); 
%         title('KDE Color-Coded Scatter Plot');
    end
    jpg_filename = sprintf('%sBCEABaselineColor.jpg', (fileNameWithoutExt));
    eps_filename = sprintf('%sBCEABaselineColor.eps', (fileNameWithoutExt));
    saveas(gcf, jpg_filename, 'jpg');
    saveas(gcf, eps_filename, 'epsc');
        
end        
close all
%%

for i = 1:length(fileList)
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name; 
    [~,fileNameWithoutExt,~] = fileparts(fullFileName);
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    if ismember(fullFileName, specificFiles) 

        fh = figure(i);
        fh.WindowState = 'maximized';
        data_density = [data.(fileNameWithoutExt).x_baseline, data.(fileNameWithoutExt).y_baseline];

        [density, ~] = ksdensity(data_density, data_density, 'Bandwidth', []);

        % Normalize density for colormap
        densityNorm = (density - min(density)) / (max(density) - min(density));

        % Plot
        scatter(data.(fileNameWithoutExt).x_baseline, data.(fileNameWithoutExt).y_baseline, 20, densityNorm, 'filled');
        hold on
        grid on
        colormap(cool(256));
        colorbar;
        xlabel('X decentration (min arc)');
        ylabel('Y decentration (min arc)');
        set(gca, 'FontSize', 30);
        xlim([0, 2000]);  
        ylim([0, 1100]); 
%         title('KDE Color-Coded Scatter Plot');
    end
    jpg_filename = sprintf('%sBCEABaselineColorCool.jpg', (fileNameWithoutExt));
    eps_filename = sprintf('%sBCEABaselineColorCool.eps', (fileNameWithoutExt));
    saveas(gcf, jpg_filename, 'jpg');
    saveas(gcf, eps_filename, 'epsc');
        
end        
close all

%% Table packing

subjectIDs={};

STD_x_table=[];
STD_y_table=[];
MEAN_x_table=[];
MEAN_y_table=[];
RHO_table=[];
BCEA_table=[];
Guziks_table=[];
MSE_table=[];
SampEntX_table=[];
SampEntY_table=[];
AppEntX_table=[];
AppEntY_table=[];
num_PRL_table=[];
subjectIndex = 1; 

for i = 1:length(fileNames) 
    filePath = fullfile(folderPath, fileList(i).name);  
    fullFileName = fileList(i).name;     
    [~, fileNameWithoutExt, ~] = fileparts(fullFileName);  
    fileNameWithoutExt = matlab.lang.makeValidName(fileNameWithoutExt); 
    if ismember(fullFileName, specificFiles) 

       
        STD_x=data.(fileNameWithoutExt).sigma_x_baseline;
        STD_y=data.(fileNameWithoutExt).sigma_y_baseline;
        MEAN_x=data.(fileNameWithoutExt).mean_x_baseline;
        MEAN_y=data.(fileNameWithoutExt).mean_y_baseline;
        RHO=data.(fileNameWithoutExt).rho_baseline;
        BCEA=data.(fileNameWithoutExt).BCEA_baseline;
        GuziksIndex=data_section.(fileNameWithoutExt).guziksIndex;
        MSE=data_section.(fileNameWithoutExt).MSE_major_axis;
        SampEntX_mean=data.(fileNameWithoutExt).SampEntX_mean;
        AppEntX=data.(fileNameWithoutExt).AppEntX;
        SampEntY_mean=data.(fileNameWithoutExt).SampEntY_mean;
        AppEntY=data.(fileNameWithoutExt).AppEntY;
        NumPRL=data.(fileNameWithoutExt).numPRLs; 
       
        subjectIDs{end + 1} = fileNameWithoutExt;

        STD_x_table(subjectIndex)=STD_x;
        STD_y_table(subjectIndex)=STD_y;
        MEAN_x_table(subjectIndex)=MEAN_x;
        MEAN_y_table(subjectIndex)=MEAN_y;
        RHO_table(subjectIndex)=RHO;
        BCEA_table(subjectIndex)=BCEA;
        num_PRL_table(subjectIndex)=NumPRL;
        Guziks_table(subjectIndex)=GuziksIndex;
        MSE_table(subjectIndex)=MSE;
        SampEntX_table(subjectIndex)=SampEntX_mean;
        AppEntX_table(subjectIndex)=AppEntX;
        SampEntY_table(subjectIndex)=SampEntY_mean;
        AppEntY_table(subjectIndex)=AppEntY;
        BCEAmapBaseline= table(STD_x,STD_y,MEAN_x,MEAN_y,RHO,BCEA,GuziksIndex,MSE,SampEntX_mean,AppEntX,SampEntY_mean,AppEntY,NumPRL);
        BCEAcsvFilePath = [(fileNameWithoutExt),'_BCEABaseline', '.csv'];
        writetable(BCEAmapBaseline,BCEAcsvFilePath,'Delimiter',',');
        subjectIndex = subjectIndex + 1;

    end
end
FeaturesTable = table(subjectIDs',MEAN_x_table',STD_x_table',MEAN_y_table',STD_y_table',RHO_table',BCEA_table',num_PRL_table',Guziks_table',MSE_table', SampEntX_table',AppEntX_table',SampEntY_table',AppEntY_table','VariableNames', {'SubjectID','MeanHoriz','StdHoriz','MeanVert','StdVert','RHO','BCEA','Estimated PRL','Guziks Index', 'MSE','Sample Entropy Horiz', 'App Entropy Horiz', 'Sample Entropy Vert','App Entropy Vert'});
featurescsvFilePath = ['BCEA_BaselineValues', '.csv'];
writetable(FeaturesTable,featurescsvFilePath,'Delimiter',',');


