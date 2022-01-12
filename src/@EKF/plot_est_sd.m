function [fig, axes] = plot_est_sd(EKF, states, x_vec, oneAxis, varargin)

% INPUTS:
%   - states: Indices of states that we want to draw the estimation error
%             for
%   - x_vec: The x-coordinate vector (if empty, the default is the time
%            vector inside the EKF object
%   - varargin: (optional) plot options (e.g 'LineWidth', 1.5)

n_states = length(states);
axes = cell(1, n_states);
legends = cell(1, n_states);

fig = figure;
if oneAxis
    hold on;
    for i = 1:n_states
        y_vec   = sqrt(squeeze(EKF.P(states(i), states(i), :)))';
        axes{i} = plot(x_vec,  y_vec, varargin{:});
        legends{i} = ['state ', num2str(states(i))];
    end
    grid on;
    box on;
    xlabel('Time');
    ylabel('Estimation standard deviation');
    legend(legends);
else
    for i = 1:n_states    
        y_vec = sqrt(squeeze(EKF.P(states(i), states(i), :)));
        i_str = floor(length(y_vec)/5);
        av    = mean(y_vec(i_str:end));
        sigma = std(y_vec(i_str:end));
        subplot(n_states, 1, i);
        axes{i} = plot(x_vec,  y_vec, varargin{:});
        grid on;
        box on;
        ylabel(['Est. StD of state ', num2str(states(i))]);
        ylim(av+4*[-sigma, sigma]);
        if i == n_states
            xlabel('Time');
        else
            xticks([]);
        end
    end
end

end