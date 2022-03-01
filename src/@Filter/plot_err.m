function [] = plot_err(obj, states, x_vec, opts, varargin)
% PLOT_ERR plots the error of the chosed estimated states compared to the
% ground truth
% 
% INPUTS:
%   - states: Indices of states that we want to draw the estimation error
%             for
%   - x_vec: The x-coordinate vector (if empty, the default is the time
%            vector inside the obj object
%   - opts (optional): A cell array that contains the options of the plot.
%       Options should be passed as opts = {'property', value}. The set of
%       properties that can be passed are:
%           - 'OneAxis', value(boolean): specifies whether to stack all 
%             the plots on one axis or create subplots.
%           - 'ylabel' / 'legend', value (cell array of strings): specifies
%             the ylabels for the subplots or the legends for lines on one 
%             axis or the legends for
%           - ylim, value (array): specifies the ylim of the axis/axes.
%           - ShowPatch, value (boolean): specifies whether to show a gray 
%             shading in the background of the estimated error indicating
%             +- 3 sigma, where sigma is the estimated standerd deviation
%             at each iterations
%   - varargin: (optional) plot options (e.g 'LineWidth', 1.5)
%
% Copyrights: Ahmed Mahfouz 2022, University of Luxembourg.

n_states = length(states);
legends = cell(1, n_states);

oneAxis   = false;
showPatch = false;
ylabels   = [];
ylims     = [];
for i = 1:length(opts)
    if ischar(opts{i})
        if strcmpi(opts{i}, 'ylabel') || strcmpi(opts{i}, 'legend')
                ylabels = opts{i+1};
        elseif strcmpi(opts{i}, 'ylim')
                ylims = opts{i+1};
        elseif strcmpi(opts{i}, 'oneaxis')
                oneAxis = opts{i+1};
        elseif strcmpi(opts{i}, 'showpatch')
                showPatch = opts{i+1};
        else
            warning(['Invalid option ', opts{i}, ' for plot_err'])
        end
    end
end

figure;
if oneAxis
    hold on;
    for i = 1:n_states
        y_vec = obj.Y(states(i), :)-obj.Y_GT(states(i), :);
        x_vec = x_vec(~isnan(y_vec));
        y_vec = y_vec(~isnan(y_vec));
        plot(x_vec,  y_vec, varargin{:});
        if isempty(ylabels)
            legends{i} = ['State ', num2str(states(i))];
        else
            if length(ylabels)~=n_states
                error('YLABELS is a cell array that contains the ylabels of each axis. length(ylabels) must equal the numebr of states to be plotted.')
            else
                legends{i} = ylabels{i};
            end
        end
    end
    grid on;
    box on;
    xlabel('Time', 'interpreter', 'latex');
    ylabel('Error', 'interpreter', 'latex');
    legend(legends, 'Interpreter', 'latex');
    
    obj.set_datetimeTicks(gca, x_vec);
    obj.set_ylim([], y_vec, 0, ylims);
    
else
    for i = 1:n_states    
        y_vec = obj.Y(states(i), :)-obj.Y_GT(states(i), :);
        cond  = ~isnan(y_vec);
        x_vec = x_vec(cond);
        y_vec = y_vec(cond);
        subplot(n_states, 1, i);
        h = plot(x_vec,  y_vec, varargin{:});
        if showPatch
            sigma_est = obj.show_patch_err(obj.P(i, i, cond), x_vec, showPatch);
        else
            sigma_est = std(y_vec);
        end
        obj.set_datetimeTicks(gca, x_vec);
        [av, RMS, perc] = obj.set_ylim([], y_vec, sigma_est, ylims);
        uistack(h, 'top');
        grid on;
        box on;
        
        title(sprintf('RMS = %4.2f, with %2.1f%% < 3%s, and mean = %2.2f', round(RMS, 2), round(perc, 1), '\sigma', round(av, 2)));

        if isempty(ylabels)
            ylabel(['Error in state ', num2str(states(i))], 'interpreter', 'latex');
        else
            if length(ylabels)~=n_states
                warning('YLABELS is a cell array that contains the ylabels of each axis. length(ylabels) must equal the numebr of states to be plotted.')
            else
                ylabel(ylabels{i}, 'interpreter', 'latex');
            end
        end
        
        if i == n_states
            xlabel('Time', 'interpreter', 'latex');
        end
    end
end
end

