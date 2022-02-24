classdef EKF < Filter
% EKF is an Extended Kalman Filter class which is able to estimate the
% states using the Extended Kalman Filter algorithm.
%
% Use EKF() to Construct an instance of the Extended Kalman Filter class
% 
% INPUTS
%   - n_st: number of state variables to be estimated
%   - [Y(k), STM] = st_model(t(k-1), t(k), Y(k-1), P(k-1)): is 
%     a propagating function. The output of this function must
%     be [Y(t), STM] where STM is the state transition matrix between the 
%     two time instants (t(k-1)) and (t(k))
%   - z = meas(t): a function that returns the measurement vector at time 
%     t(k).
%   - [h, H, z] = meas_model(t,Y, z): is the measurement model 
%     function. The output must be the vector h of modeled 
%     measurements, the matrix H which is dh/dY, and optionally
%     the measrement vector after removing outlaiar measuremets.
%   - Q: state model covarience matrix (constant or callable),
%     Q(t, Y_pred)
%   - R: measurement covarience matrix (constant or callable),
%     Q(t, Y_pred)
% 
% Copyrights: Ahmed Mahfouz 2022, University of Luxembourg.
    
    properties
        z           % Measurements (Cell array of all measurements)
        P           % Estimation covariance matrix
        st_model    % state model
        meas_model  % measurement model
        meas        % A function that produces the measurements at any time
        aux_pred    % Auxiliary function to be run after the prediction step (Callable)
        aux_corr    % Auxiliary function to be run after the correction step (Callable)
    end
    
    methods
        function obj = EKF(n_st, st_model, meas_model, meas, Q, R)            
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
                
        function set.aux_pred(EKF, aux_pred)
            validateattributes(aux_pred, {'function_handle'}, {});
            EKF.aux_pred = aux_pred;
        end
        
        function set.aux_corr(EKF, aux_corr)
            validateattributes(aux_corr, {'function_handle'}, {});
            EKF.aux_corr = aux_corr;
        end
        
        EKF         = estimate(EKF, t_vec, Y0, P0);
    end
    
    methods (Access=private, Static)
        function varargout = nochange(varargin)
            varargout = varargin;
        end
    end
end

