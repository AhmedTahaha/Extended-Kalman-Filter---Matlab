function obj = estimate(obj, t_vec, Y0, P0)
% ESTIMATE(ekf, t_vec, Y0, P0) estimates the states of ekf object for the
% time instants indicated by t_vec in a post-processing manner, i.e. the
% measurements are not collected during the estimation process, but are 
% rather collected before the estimation process.
%
% INPUTS
%   - t_vec: a vector of all the time instants for wich the states need to
%     be estimated
%   - Y0: initial guess of the state at time 0
%   - P0: initial guess of the estimate covarience matrix

if obj.waitbar
    bar = waitbar(0, 'Initiating estimation', 'Name', 'Extended Kalman Filter',...
                  'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    pause(0.2);
    setappdata(bar,'canceling',0);
end 

obj.Y         = nan(obj.n_st, length(t_vec));
obj.P         = nan(obj.n_st, obj.n_st, length(t_vec));
obj.Y(:, 1)   = Y0;
obj.P(:, :,1) = P0;
obj.t         = t_vec';
n_total       = length(t_vec);
obj.z         = cell(1, n_total);
for i = 2:n_total
    t0 = t_vec(i-1);
    t  = t_vec(i);

    % Prediction
    [Y_pred, Phi] = obj.st_model(t0, t, obj.Y(:, i-1), obj.P(:, :, i-1));
    if isa(obj.Q, 'function_handle')
        Q = obj.Q(t, Y_pred);
    elseif isa(obj.Q, 'double')
        Q = obj.Q;
    else
        error('EKF.Q must be either a constant matrix or a callable(t, Y)');
    end
    P_pred = Phi * obj.P(:, :, i-1) * Phi';
    [Y_pred, P_pred] = obj.aux_pred(Y_pred, P_pred);
    P_pred = P_pred + Q;

    % Correction
    z               = obj.meas(t);
    obj.z{i}        = z;
    if isempty(z)
        obj.Y(:, i)     = Y_pred;
        obj.P(:, :, i)  = P_pred;
    else
        [h, H, z] = obj.meas_model(t, Y_pred, P_pred, z);

        if isa(obj.R, 'function_handle')
            R = obj.R(t, z);
        elseif isa(obj.R, 'double')
            R = obj.R;
        else
            error('EKF.R must be either a constant matrix or a callable(t, z)');
        end
        S                   = H * P_pred * H' + R;
        meas_res  = z - h;
        
        K                = P_pred * H' / S;
        Y_corr           = Y_pred + K * meas_res;
        P_corr           = (eye(obj.n_st) - K*H) * P_pred;
        [Y_corr, P_corr] = obj.aux_corr(Y_corr, P_corr);
        obj.Y(:, i)      = Y_corr;
        obj.P(:, :, i)   = P_corr;
    end
    if obj.waitbar
        if getappdata(bar,'canceling')
            break
        end
        waitbar(i/n_total, bar, 'Estimating...')
    end
end
if obj.waitbar
    waitbar(1, bar, 'Estimation over')
    pause(0.2);
    delete(bar);
end
end