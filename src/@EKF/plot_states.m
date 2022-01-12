function [fig, axes] = plot_states(EKF, states, x_vec, oneAxis, varargin)
% PLOT_CUSTOM plots the chosed estimated states
% INPUTS:
%   - states: Indices of states that we want to draw the estimation error
%             for
%   - x_vec: The x-coordinate vector (if empty, the default is the time
%            vector inside the EKF object
%   - varargin: (optional) plot options (e.g 'LineWidth', 1.5)

n_states = length(states);
axes = cell(1, n_states);
legends = cell(1, n_states);

if isempty(x_vec)
    x_vec = EKF.t;
end

fig = figure;
if oneAxis
    hold on;
    for i = 1:n_states
        axes{i} = plot(x_vec,  EKF.Y(states(i), :), varargin{:});
        legends{i} = ['state ', num2str(states(i))];
    end
    grid on;
    box on;
    xlabel('Time');
    ylabel('Estimated states');
    legend(legends);
else
    for i = 1:n_states
        subplot(n_states, 1, i);
        axes{i} = plot(x_vec,  EKF.Y(states(i), :), varargin{:});
        grid on;
        box on;
        ylabel(['state ', num2str(states(i))]);
        if i == n_states
            xlabel('Time');
        else
            xticks([]);
        end
    end
end
end