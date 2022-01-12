classdef EKF < handle
    % EKF is an Extended Kalman Filter class which is able to estimate the
    % states using the Extended Kalman Filter algorithm. It also provides
    % some visualization features.
    %
    % Copyrights: Ahmed Mahfouz 2021, University of Luxembourg.
    
    properties
        n_st        % number of states
        t           % time vector
        Y           % state variavles
        z           % measurements
        Y_GT        % Ground truth of the state variables (n_stxM vector)
        P           % Estimation covariance matrix
        Q           % state model covariance matrix
        R           % measurements covariance matrix
        st_model    % state model
        meas_model  % measurement model
        meas        % A function that produces the measurements at any time
        waitbar     % A boolean indicating whether to show a waitbar or not
        aux_pred    % Auxiliary function to be run after the prediction step
        aux_corr    % Auxiliary function to be run after the correction step
    end
    
    methods
        function obj = EKF(n_st, st_model, meas_model, meas, Q, R)
            %EKF Construct an instance of the Extended Kalman Filter class
            % INPUTS
            %   - n_st: number of state variables to be estimated
            %   - [Y(k), Phi] = st_model(t(k-1), t(k), Y(k-1), P(k-1)): is 
            %     a propagating function. The output of this function must
            %     be [Y(t), Phi] where Phi is the STM   between the two
            %     time instants (t(k-1)) and (t(k))
            %   - z = meas(t): a function that returns the measurement
            %     vector at time.
            %   - [h, H, z] = meas_model(t,Y, z): is the measurement model 
            %     function. The output must be the vector h of modeled 
            %     measurements, the matrix H which is dh/dY, and optionally
            %     the measrement vector after removing outlaiar
            %     measuremets.
            %   - Q: state model covarience matrix (constant or callable),
            %     Q(t, Y_pred)
            %   - R: measurement covarience matrix (constant or callable),
            %     Q(t, Y_pred)
            
            obj.n_st       = n_st;
            obj.st_model   = st_model;
            obj.meas_model = meas_model;
            obj.meas       = meas;
            obj.Q          = Q;
            obj.R          = R;
            obj.Y_GT       = nan(n_st, 1);
            obj.waitbar    = false;
            obj.z          = {}; 
            obj.aux_pred   = @(Y_pred, P_pred) obj.nochange(Y_pred, P_pred);
            obj.aux_corr   = @(Y_corr, P_corr) obj.nochange(Y_corr, P_corr);
        end
        
        function set.Y_GT(EKF, Y_GT)
            validateattributes(Y_GT, { 'numeric' }, {'size', [EKF.n_st, nan]});
            EKF.Y_GT = Y_GT;
        end
        
        function set.waitbar(EKF, waitbar)
            validateattributes(waitbar, {'logical'}, {});
            EKF.waitbar = waitbar;
        end
        
        function set.aux_pred(EKF, aux_pred)
            validateattributes(aux_pred, {'function_handle'}, {});
            EKF.aux_pred = aux_pred;
        end
        
        function set.aux_corr(EKF, aux_corr)
            validateattributes(aux_corr, {'function_handle'}, {});
            EKF.aux_corr = aux_corr;
        end
        
        EKF         = estimate(EKF, t_vec, Y0, P0);
        [fig, axes] = plot_states(EKF, states, x_vec, oneGraph, varargin);
        [fig, axes] = plot_err(EKF, states, x_vec, oneGraph, varargin);
        [fig, axes] = plot_est_sd(EKF, states, x_vec, oneGraph, varargin);
        [fig, ax]   = plot_custom(EKF, fun, x_vec, ylabel, varargin)
        [fig, axes] = plot_err_xyz(EKF, states, x_vec, oneAxis, varargin)
    end
    
    methods (Access=private, Static)
        function varargout = nochange(varargin)
            varargout = varargin;
        end
    end
end

