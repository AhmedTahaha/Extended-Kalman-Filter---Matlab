function [] = plot_states(obj, states, x_vec, opts, varargin)
% PLOT_STATES plots the chosed estimated states 
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
%           - pltGT, value (boolean): specifies wether to plot the ground
%             truth alongside the states or not.
%       
%   - varargin: (optional) plot options (e.g 'LineWidth', 1.5)
%
% Copyrights: Ahmed Mahfouz 2022, University of Luxembourg.

n_states = length(states);
legends = cell(1, n_states);

oneAxis   = false;
ylabels   = [];
ylims     = [];
pltGT     = true;
for i = 1:length(opts)
    if ischar(opts{i})
        if strcmpi(opts{i}, 'ylabel') || strcmpi(opts{i}, 'legend')
                ylabels = opts{i+1};
        elseif strcmpi(opts{i}, 'ylim')
                ylims = opts{i+1};
        elseif strcmpi(opts{i}, 'oneaxis')
                oneAxis = opts{i+1};
        elseif strcmpi(opts{i}, 'pltGT')
                pltGT = opts{i+1};
        else
            warning(['Invalid option ', opts{i}, ' for plot_states'])
        end
    end
end

figure;
if oneAxis
    hold on;
    for i = 1:n_states
        y_vec = obj.Y(states(i), :);
        cond  = ~isnan(y_vec);
        x_vec = x_vec(cond);
        y_vec = y_vec(cond);
        h     = plot(x_vec,  y_vec, varargin{:});
        if pltGT
            y_GT  = obj.Y_GT(states(i), cond);
            plot(x_vec,  y_GT, varargin{:});
        end
        uistack(h, 'top');
        grid on;
        box on;
        
        if isempty(ylabels)
            legends{i} = ['State ', num2str(states(i))];
        else
            if length(ylabels)~=n_states
                warning('YLABELS is a cell array that contains the ylabels of each axis. length(ylabels) must equal the numebr of states to be plotted.')
            else
                legends{i} = ylabels{i};
            end
        end
    end
    xlabel('Time', 'interpreter', 'latex');
    ylabel('States', 'interpreter', 'latex');
    if pltGT
        n_leg = length(legends);
        leg_temp = cell(1, 2*n_leg);
        for i = 1:length(legends)
            leg_temp{2*i-1} = ['Ground truth of ', legends{i}];
        end
        for i = 1:length(legends)
            leg_temp{2*i} = ['Estimated ', legends{i}];
        end
        legends = leg_temp;
    end
    legend(legends, 'Interpreter', 'latex');
    
    obj.set_datetimeTicks(gca, x_vec);
    if ~isempty(ylims)
        set(gca, 'Ylim', ylims);
    end
    
else
    for i = 1:n_states
        y_vec = obj.Y(states(i), :);
        cond  = ~isnan(y_vec);
        x_vec = x_vec(cond);
        y_vec = y_vec(cond);
        subplot(n_states, 1, i);
        
        h = plot(x_vec,  y_vec, varargin{:});
        
        if pltGT
            y_GT  = obj.Y_GT(states(i), cond);
            hold on
            plot(x_vec,  y_GT, varargin{:});
            hold off
            legend({'Estimation', 'Ground truth'}, 'interpreter', 'latex');
        end
        
        obj.set_datetimeTicks(gca, x_vec);
        if ~isempty(ylims)
            set(gca, 'Ylim', ylims);
        end
        uistack(h, 'top');
        grid on;
        box on;
        
        
        if isempty(ylabels)
            ylabel(['State ', num2str(states(i))], 'interpreter', 'latex');
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

