function [threshold,noise_mean, noise_std] = IVT_algorithm(velocity,n)


minPeak=100;
initialThreshold=200;

thresholdDiff=Inf;
iterations=0;
adaptive_threshold=initialThreshold;
T=[];
while thresholdDiff>1
    T=[T initialThreshold];
    noise=velocity(velocity<adaptive_threshold);
    noise_mean=mean(noise);
    noise_std=std(noise);

    newThreshold=noise_mean+n*noise_std;
    thresholdDiff=abs(adaptive_threshold-newThreshold);
    
    adaptive_threshold=newThreshold;
    iterations=iterations+1;
    initialThreshold=newThreshold;
    if adaptive_threshold<minPeak
        warning('Threshold did not converge. Returning initial threshold.');
        threshold = initialThreshold;
        return;
    end
end
threshold = adaptive_threshold;

end

