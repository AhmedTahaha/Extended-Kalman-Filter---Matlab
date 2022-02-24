function [] = plot_custom(obj, fun, x_vec, opts, varargin)
% SCATTER_CUSTOM scatters a custom function of the states in the obj object
% INPUTS:
%   - fun(obj): a custom function that handles the data in obj object and
%               returns a vector of the length as x_vec
%   - x_vec: The x-coordinate vector (if empty, the default is the time
%            vector inside the obj object
%   - opts: Options of the plot
%   - varargin: (optional) scatter options (e.g 'LineWidth', 1.5)


ylabels = [];
ylims = [];
for i = 1:length(opts)
    if ischar(opts{i})
        if strcmpi(opts{i}, 'ylabel')
                ylabels = opts{i+1};
        elseif strcmpi(opts{i}, 'ylim')
                ylims = opts{i+1};
        else
            error(['Unvalid option ', opts{i}, ' for plot_custom'])
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
[~, RMS, ~, conv_time] = obj.set_ylim(x_vec, y_vec, 0, ylims);

title(sprintf('RMS = %4.2f, and the filter converges after %d iterations', RMS, conv_time));

end
