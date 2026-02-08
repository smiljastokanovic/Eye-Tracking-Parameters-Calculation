function dx = central_der(x,Ts)
% Calculate the central differential of vector x
% Input
%     x -  1D vector
%     Ts - sampling period
% Output
%     dx - central differential
    dx = zeros(size(x));
    dx(2:end-1) = (x(3:end) - x(1:end-2)) / (2 * Ts);
    dx(1) = (x(2) - x(1)) / Ts;              % Forward difference at the start
    dx(end) = (x(end) - x(end-1)) / Ts;      % Backward difference at the end
    
end
