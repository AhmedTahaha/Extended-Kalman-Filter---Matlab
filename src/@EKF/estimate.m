function EKF = estimate(EKF, t_vec, Y0, P0)
% INPUTS
%   - t_vec: a vector of all
%   - Y0: initial guess of the state at time 0
%   - P0: initial guess of the estimate covarience matrix

if EKF.waitbar
    bar = waitbar(0, 'Initiating estimation', 'Name', 'Extended Kalman Filter',...
                  'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    pause(0.2);
    setappdata(bar,'canceling',0);
end 

EKF.Y         = nan(EKF.n_st, length(t_vec));
EKF.P         = nan(EKF.n_st, EKF.n_st, length(t_vec));
EKF.Y(:, 1)   = Y0;
EKF.P(:, :,1) = P0;
EKF.t         = t_vec';
n_total       = length(t_vec);
EKF.z         = cell(1, n_total);
for i = 2:n_total
    t0 = t_vec(i-1);
    t  = t_vec(i);

    % Prediction
    [Y_pred, Phi] = EKF.st_model(t0, t, EKF.Y(:, i-1), EKF.P(:, :, i-1));
    if isa(EKF.Q, 'function_handle')
        Q = EKF.Q(t, Y_pred);
    elseif isa(EKF.Q, 'double')
        Q = EKF.Q;
    else
        error('EKF.Q must be either a constant matrix or a callable(t, Y)');
    end
    P_pred = Phi * EKF.P(:, :, i-1) * Phi' + Q;
    [Y_pred, P_pred] = EKF.aux_pred(Y_pred, P_pred);
    
    % Correction
    z               = EKF.meas(t);
    EKF.z{i}        = z;
    if isempty(z)
        EKF.Y(:, i)     = Y_pred;
        EKF.P(:, :, i)  = P_pred;
    else
        [h, H, z] = EKF.meas_model(t, Y_pred, P_pred, z);
        if isa(EKF.R, 'function_handle')
            R = EKF.R(t, z);
        elseif isa(EKF.R, 'double')
            R = EKF.R;
        else
            error('EKF.R must be either a constant matrix or a callable(t, z)');
        end
%         if i > 20
%             S              = H * P_pred * H' + R;
%             [h, H, z, R] = chi2RemoveOutliers(z, h, H, S, R);
%         end
        meas_res  = z - h;
        S                = H * P_pred * H' + R;
        K                = P_pred * H' /S;
        Y_corr           = Y_pred + K * meas_res;
        P_corr           = (eye(EKF.n_st) - K*H) * P_pred;
        [Y_corr, P_corr] = EKF.aux_corr(Y_corr, P_corr);
        EKF.Y(:, i)      = Y_corr;
        EKF.P(:, :, i)   = P_corr;
    end
    if EKF.waitbar
        if getappdata(bar,'canceling')
            break
        end
        waitbar(i/n_total, bar, 'Estimating...')
    end
end
if EKF.waitbar
    waitbar(1, bar, 'Estimation over')
    pause(0.2);
    delete(bar);
end
end