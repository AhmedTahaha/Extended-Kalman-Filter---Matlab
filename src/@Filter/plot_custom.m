function [] = plot_custom(obj, fun, x_vec, opts, varargin)
% PLOT_CUSTOM plots a custom function of the attributes in the obj object
% 
% INPUTS:
%   - fun(obj): a custom function that handles the data in obj object and
%               returns a vector of the length as x_vec
%   - x_vec: The x-coordinate vector (if empty, the default is the time
%            vector inside the obj object
%   - opts (optional): A cell array that contains the options of the plot.
%       Options should be passed as opts = {'property', value}. The set of
%       properties that can be passed are:
%           - 'ylabel' / 'legend', value (cell array of strings): specifies
%             the ylabels for the subplots or the legends for lines on one 
%             axis or the legends for
%           - ylim, value (array): specifies the ylim of the axis/axes.
%   - varargin: (optional) scatter options (e.g 'LineWidth', 1.5)
% 
% Copyrights: Ahmed Mahfouz 2022, University of Luxembourg.


ylabels = [];
ylims = [];
for i = 1:length(opts)
    if ischar(opts{i})
        if strcmpi(opts{i}, 'ylabel')
                ylabels = opts{i+1};
        elseif strcmpi(opts{i}, 'ylim')
                ylims = opts{i+1};
        else
            warning(['Invalid option ', opts{i}, ' for plot_custom'])
        end
    end
end

figure;
if isempty(x_vec)
    x_vec = obj.t;
end

y_vec = fun(obj);
x_vec = x_vec(~isnan(y_vec));
y_vec = y_vec(~isnan(y_vec));
plot(x_vec,  y_vec, varargin{:});
xlabel('Time', 'interpreter', 'latex');
if isempty(ylabels)
    ylabel('Custom function', 'Interpreter', 'latex');
else
    ylabel(ylabels, 'Interpreter', 'latex');
end
grid on;
box on;
obj.set_datetimeTicks(gca, x_vec);
[~, RMS, ~, ~, conv_i] = obj.set_ylim(x_vec, y_vec, 0, ylims);

title(sprintf('RMS = %4.2f, and the filter converges after %d iterations', RMS, conv_i));

end
