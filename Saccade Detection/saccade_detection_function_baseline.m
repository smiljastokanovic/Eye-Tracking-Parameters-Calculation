function DATA = saccade_detection_function_baseline(raw_data,t, raw_PT, raw_noise, raw_std)
% Algorithm for saccade detection and extraction of statistical features.
% Saccade detection is performed based on the velocity calculated using horizontal and vertical angle,
% inspired by the algorithm described in Nystrom and Holmqvist (2010).
% Finally, relevant information and statistical features of saccades are extracted.

% INPUT:
%     data - 2D vector where columns represent horizontal and vertical visual angles
%     t - time axis
% OUTPUT:
%     DATA - a structure containing the following information:
%         DATA.GAZE.t - time axis [s]
%         DATA.GAZE.amp - absolute amplitude of eye movement angle [deg]
%         DATA.GAZE.vel - eye movement velocity [deg/s]
% 
%         DATA.SACC.peak_vals - peak saccade velocities [deg/s]
%         DATA.SACC.peak_idxs - indices of saccade velocity peaks
%         DATA.SACC.onsets - indices of saccade onsets
%         DATA.SACC.offsets - indices of saccade offsets
%         DATA.SACC.durations - saccade durations [ms]
%         DATA.SACC.gaze_times - fixation durations/intervals between saccades [ms]
%         DATA.SACC.amplitudes - saccade amplitudes [deg]
%         DATA.SACC.traj - array of saccade trajectories [deg]
%         DATA.SACC.traj_t - array of times corresponding to saccade trajectories [s]

% defining constants related to the experiment setup

Fs = 100;

% Normalized Tobii gaze coordinates (0 to 1)
norm_x = raw_data(:, 1); % Horizontal gaze (0 to 1)
norm_y = raw_data(:, 2); % Vertical gaze (0 to 1)

% Convert normalized coordinates to real-world positions on paper (in cm)
% raw_x = norm_x * paper_size_cm(1); % Horizontal position in cm
% raw_y = norm_y * paper_size_cm(2); % Vertical position in cm
% visualization of the subject screen view
deg_x = raw_data(:, 1);
deg_y = raw_data(:, 2);

%% Filtering
filt_x = deg_x;
filt_y = deg_y;

%% Calculates the position (amplitude) and speed of eyeball movement
% analysis is performed only on horizontal saccades
% gaze_amp = filt_x; 
fi_1=95/1920;
fi_2=63/1080;
fs=100;

gaze_vel_x = gradient(filt_x, 1/Fs);
gaze_vel_y = gradient(filt_y, 1/Fs);
gaze_vel = sqrt((fi_1*gaze_vel_x).^2 + (fi_2*gaze_vel_y).^2);
med_val = median(gaze_vel);
time_iv = 0:1/fs:(length(raw_data)-1)/fs;

% gaze_vel_x = abs(central_der(filt_x', 1/Fs));
% gaze_vel_y = abs(central_der(filt_y', 1/Fs));   
% gaze_vel=sqrt(gaze_vel_x.^2 + gaze_vel_y.^2);

gaze_vel(gaze_vel < med_val | gaze_vel > 1000) = 0;
gaze_amp_x=filt_x;
gaze_amp_y=filt_y;
%% Saccade detection algorithm %% 

% Threshold initialization
fs=100;
minimumDistance=0.05;
minN=2.5;
maxN=6;
    
%% Saccade detection
% detecting peaks
[peak_vals,peak_idxs] = findpeaks(gaze_vel, "MinPeakDistance", minimumDistance, "MinPeakHeight", raw_PT);
noise_mean=raw_noise;
noise_std=raw_std;
% onset detection 
T_onset = noise_mean + 3*noise_std;
onset_idxs = [];
for ind = 1:length(peak_idxs)
    jt = 1; 
    % iteratively finding the first local minimum to the left of the peak
    while 1
       if peak_idxs(ind) - jt - 1 == 0 % edge case
           onset_idxs = [onset_idxs 1];
           break;
       end
        if gaze_vel(peak_idxs(ind) - jt) < T_onset 
           if gaze_vel(peak_idxs(ind) - jt) - gaze_vel(peak_idxs(ind) - jt - 1) <= 0
                onset_idxs = [onset_idxs peak_idxs(ind) - jt]; 
                break;
            end
        end
        jt = jt + 1;
    end
end

% offset detection
noise_window = minimumDistance;% floor(Fs/1000*40); % 40 ms window
a = 0.7;
b = 0.3;
offset_idxs = [];

for ind = 1 : length(peak_idxs)
    local_noise = mean(gaze_vel(max(peak_idxs(ind)-noise_window,1): peak_idxs(ind)));
    T_offset = a*T_onset + b*local_noise;
    jt = 1;
    % iteratively finding the first local minimum to the right of the peak
    while 1
        if peak_idxs(ind) + jt + 1 > length(gaze_vel) % edge case
            offset_idxs = [offset_idxs length(gaze_vel)]; 
            break;
        end
        if gaze_vel(peak_idxs(ind) + jt) < T_offset 
           if gaze_vel(peak_idxs(ind) + jt) - gaze_vel(peak_idxs(ind) + jt + 1 ) <= 0
                offset_idxs = [offset_idxs peak_idxs(ind) + jt]; 
                break;
            end
        end
        jt = jt + 1;
    end
end

offset_vals = gaze_vel(offset_idxs);
onset_vals = gaze_vel(onset_idxs);
durations = offset_idxs-onset_idxs;
valid = ones(1, length(durations));

% Rejection of irregular saccades
min_duration = ceil(Fs/1000*10);
valid(durations < min_duration) = 0; % Saccades shorter than 10 ms are discarded
valid(peak_vals > 1000) = 0; % Saccades higher than 1000 deg/s are not possible

% problem where the saccade offset is not found well
for ind = 2:length(valid)
    if valid(ind) == 0
        continue
    end
    if peak_idxs(ind) < offset_idxs(ind-1) % finding invalid peaks 
        valid(ind) = 0;
    end
end

disp(["Excluded number of samples: " num2str(length(find(valid == 0)))])
peak_idxs = peak_idxs(valid == 1);
onset_idxs1 = onset_idxs(valid == 1);
offset_idxs1 = offset_idxs(valid == 1);
peak_vals = peak_vals(valid == 1);
onset_vals = onset_vals(valid == 1);
offset_vals = offset_vals(valid == 1);
durations = durations(valid == 1);
gaze_times = onset_idxs(2: end) - offset_idxs(1: end-1); 
onset_idxs = unique(onset_idxs);
offset_idxs = unique(offset_idxs);

if ~issorted(onset_idxs)
    warning('onset_idxs is not sorted. Sorting now.');
    onset_idxs = sort(onset_idxs);
end

if ~issorted(offset_idxs)
    warning('offset_idxs is not sorted. Sorting now.');
    offset_idxs = sort(offset_idxs);
end

if onset_idxs(1) < offset_idxs(1)
    disp('First onset index occurs before first offset index - likely okay.');
else
    warning('First onset index occurs after first offset index - check data!');
end

min_length = min(length(onset_idxs), length(offset_idxs));
onset_idxs = onset_idxs(1:min_length);
offset_idxs = offset_idxs(1:min_length);
sacc_traj_x = cell(min_length, 1);
sacc_traj_y = cell(min_length, 1);
sacc_traj_t = cell(min_length, 1);

for ind = 1:min_length
    if onset_idxs(ind) < offset_idxs(ind)
        sacc_traj_x{ind} = gaze_amp_x(onset_idxs(ind):offset_idxs(ind));
        sacc_traj_y{ind} = gaze_amp_y(onset_idxs(ind):offset_idxs(ind));
        sacc_traj_t{ind} = t(onset_idxs(ind):offset_idxs(ind));
    
    else
        warning('Onset index is greater than or equal to offset index at ind = %d', ind);
    end
end

fixation_onsets = [];
fixation_offsets = [];

for ind = 1:min_length-1
    fix_onset = offset_idxs(ind);
    fix_offset = onset_idxs(ind + 1);
    
    if fix_onset < fix_offset
        fixation_onsets(end + 1) = fix_onset;
        fixation_offsets(end + 1) = fix_offset;
    end
end

durations = durations/Fs*1000;
gaze_times = (onset_idxs(2:end) - offset_idxs(1:end-1)) / Fs * 1000;

      
%% Calculating statistical parameters
min_length = min(length(onset_idxs1), length(offset_idxs1));
sacc_amplitudes = nan(1, min_length); % Preallocate for speed

for ind = 1:min_length
    if onset_idxs1(ind) < offset_idxs1(ind)
        % Get start and end points
        x_start = gaze_amp_x(onset_idxs1(ind));
        y_start = gaze_amp_y(onset_idxs1(ind));
        x_end = gaze_amp_x(offset_idxs1(ind));
        y_end = gaze_amp_y(offset_idxs1(ind));
        sacc_amplitudes(ind) = sqrt((x_end - x_start)^2 + (y_end - y_start)^2);
    else
        warning('Onset index >= offset index at saccade %d', ind);
        sacc_amplitudes(ind) = NaN;
    end
end
% output
DATA = struct;
DATA.GAZE.t = t;
DATA.GAZE.amp_x = gaze_amp_x;
DATA.GAZE.amp_y = gaze_amp_y;
DATA.GAZE.vel = gaze_vel;
DATA.GAZE.deg_x = deg_x;
DATA.GAZE.deg_y = deg_y;
DATA.GAZE.raw_x = raw_data(:, 1);
DATA.GAZE.raw_y = raw_data(:, 2);


DATA.SACC.peak_vals = peak_vals;
DATA.SACC.peak_idxs = peak_idxs;
DATA.SACC.onsets = onset_idxs;
DATA.SACC.offsets = offset_idxs;
DATA.SACC.durations = durations;
DATA.SACC.gaze_times = gaze_times;
DATA.SACC.gaze_temp = t(fixation_onsets);
DATA.SACC.amplitudes = sacc_amplitudes;
DATA.SACC.traj_x = sacc_traj_x;
DATA.SACC.traj_y = sacc_traj_y;
DATA.SACC.traj_t = sacc_traj_t;
DATA.SACC.PT = raw_PT;
DATA.SACC.noise_mean = noise_mean;
DATA.SACC.noise_std = noise_std;
DATA.SACC.temp_sacc=t(peak_idxs);
%DATA.SACC.optimalN_ivt=optimalN_ivt;

DATA.FIX.onsets = fixation_onsets;
DATA.FIX.offsets = fixation_offsets;
DATA.FIX.durations = (fixation_offsets - fixation_onsets) / Fs * 1000; % Convert to ms
end

