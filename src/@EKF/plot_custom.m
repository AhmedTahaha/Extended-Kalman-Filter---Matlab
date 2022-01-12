function [fig, ax] = plot_custom(EKF, fun, x_vec, y_label, varargin)
% PLOT_CUSTOM plots a custom function of the states in the EKF object
% INPUTS:
%   - fun(EKF): a custom function that handles the data in EKF object and
%               returns a vector of the length as x_vec
%   - x_vec: The x-coordinate vector (if empty, the default is the time
%            vector inside the EKF object
%   - varargin: (optional) plot options (e.g 'LineWidth', 1.5)


fig = figure;
if isempty(x_vec)
    x_vec = EKF.t;
end
y_vec = fun(EKF);
i_str = floor(length(y_vec)/5);
av    = mean(y_vec(i_str:end));
sigma = std(y_vec(i_str:end));      
ax = plot(x_vec,  y_vec, varargin{:});
grid on;
box on;
xlabel('Time');
if isempty(y_label)
    ylabel('custom function');
else
    ylabel(y_label);
end
title(['Mean = ', num2str(av), ', and StD = ', num2str(sigma)]);
if sigma ~= 0 && ~isnan(sigma)
    ylim(av+4*[-sigma, sigma]);
end
end
