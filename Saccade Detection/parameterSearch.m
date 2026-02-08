function [optimalN,misdetection_rates] = parameterSearch(velocity,fs, minN, maxN,time)


stepN=0.5;
nValues=minN:stepN:maxN; %Parameter N range
misdetectionRates = zeros(size(nValues));

for i=1:length(nValues)
    n=nValues(i);
    [threshold] = IVT_algorithm(velocity,n);

     minDistance=0.05;
     [~,saccadeLocs]=findpeaks(velocity,'MinPeakHeight',threshold,'MinPeakDistance',minDistance);
     duration = zeros(length(saccadeLocs), 1);

     for j = 1:length(saccadeLocs)
        if saccadeLocs(j) > 1  
            startIdx = find(velocity(1:saccadeLocs(j)) < threshold, 1, 'last');
        else
            startIdx = []; 
        end

         if saccadeLocs(j) < length(velocity)  
            endIdx = find(velocity(saccadeLocs(j):end) < threshold, 1, 'first') + saccadeLocs(j) - 1;
         else
            endIdx = []; 
         end

        if ~isempty(startIdx) && ~isempty(endIdx) && endIdx <= length(time) && startIdx >= 1
            duration(j) = time(endIdx) - time(startIdx);
        else
            duration(j) = NaN;
        end
     end
     duration=duration*1000;
     misdetections=sum(duration<10 | duration>100);
     misdetectionRates(i) = misdetections / length(duration);

end

[~,optimalIdx]=min(misdetectionRates);
optimalN=nValues(optimalIdx);

end

