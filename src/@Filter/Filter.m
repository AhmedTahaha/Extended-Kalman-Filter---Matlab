classdef Filter < handle
    % Filter class provides visualization features for state estimation
    % filters in a post-processing manner
    %
    % Copyrights: Ahmed Mahfouz 2022, University of Luxembourg.
    
    properties
        n_st        % number of states
        t           % time vector
        Y           % state variavles
        Y_GT        % Ground truth of the state variables (n_stxM vector)
        Q           % state model covariance matrix
        R           % measurements covariance matrix
        waitbar     % A boolean indicating whether to show a waitbar or not
    end
    
    methods
        function obj = Filter()
        end
        
        function set.Y_GT(obj, Y_GT)
            validateattributes(Y_GT, { 'numeric' }, {'size', [obj.n_st, nan]});
            obj.Y_GT = Y_GT;
        end
        
        function set.waitbar(obj, waitbar)
            validateattributes(waitbar, {'logical'}, {});
            obj.waitbar = waitbar;
        end
                
        plot_states(obj, states, x_vec, oneGraph, ylabels, varargin);
        plot_est_sd(obj, states, x_vec, oneGraph, ylabels, varargin);
        plot_err(obj, states, x_vec, opts, varargin);
        plot_custom(obj, fun, x_vec, prpts, varargin);
    end
    
    methods(Access=private, Static)
        set_datetimeTicks(axis, x_vec);
        [av, RMS, perc, conv_time, conv_i] = set_ylim(x_vec, y_vec, sigma_est, ylims);
        sigma_est = show_patch_err(P, x_vec, ptch);
        sigma_est = show_patch_states(P, x_vec, y_vec, clr)
    end
end