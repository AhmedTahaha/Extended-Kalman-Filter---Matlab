function [fig, axes] = plot_err_xyz(EKF, x_vec, oneAxis, varargin)
% PLOT_ERR plots the error of the chosed estimated states compared to the
% ground truth (indicated in the EKF object)
% INPUTS:
%   - states: Indices of states that we want to draw the estimation error
%             for
%   - x_vec: The x-coordinate vector (if empty, the default is the time
%            vector inside the EKF object
%   - varargin: (optional) plot options (e.g 'LineWidth', 1.5)

states   = 1:3;
n_states = length(states);
axes = cell(1, n_states);
legends = {'X_{err}', 'Y_{err}', 'Z_{err}'};

fig = figure;
if oneAxis
    hold on;
    for i = 1:n_states
        axes{i} = plot(x_vec,  EKF.Y(states(i), :)-EKF.Y_GT(states(i), :), varargin{:});
    end
    grid on;
    box on;
    xlabel('Time');
    ylabel('Position error (m)');
    legend(legends);
else
    for i = 1:n_states    
        y_vec = EKF.Y(states(i), :)-EKF.Y_GT(states(i), :);
        i_str = floor(length(y_vec)/5);
        av    = mean(y_vec(i_str:end));
        sigma = std(y_vec(i_str:end));
        subplot(n_states, 1, i);
        axes{i} = plot(x_vec,  y_vec, varargin{:});
        grid on;
        box on;
        switch i
            case 1
                xlabel('Time');
                ylabel('$X_{err}\;(m)$', 'Interpreter','latex');
            case 2
                xlabel('Time');
                ylabel('$Y_{err}\;(m)$', 'Interpreter','latex');
            case 3
                xlabel('Time');
                ylabel('$Z_{err}\;(m)$', 'Interpreter','latex');
        end
        title(['Mean = ', num2str(av), ', and StD = ', num2str(sigma)]);
        if sigma ~= 0 && ~isnan(sigma)
            ylim(av+20*[-sigma, sigma]);
        end
    end
end
end

