%% Saccades detection
clear all 
close all
cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\Measurement\WithoutFirstTwo')
LoadTobiiData;
cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\Baseline\WithoutFirstTwo')
LoadTobiiDataBaseline;
cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\Ride\WithoutFirstTwo')
LoadTobiiDataRide;
cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\Fog')
LoadTobiiDataFog;
% cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\PostRide')
% LoadTobiiDataPostRide;

%% BCEA
clear all
close all
cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\Baseline\WithoutFirstTwo\BCEA')
BCEABaseline;
clear all
close all
cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\Ride\WithoutFirstTwo\BCEA');
BCEARide;  
clear all
close all
cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\Fog\BCEA');
BCEAFog;
clear all 
% close all
% cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Saccade Detection\PostRide\BCEA');
% BCEAPostRide;
%% BLINKS
clear all
close all
cd('C:\Users\Smilja Stokanovic\Desktop\Ljubljana\Research paper\Raw data\MAGLA\Blink Detection')
BlinkDetection;