function [Y_pred, P_pred] = predict(EKF, i)

[Y_pred, Phi] = EKF.st_model(t0, t, EKF.Y(:, i-1), EKF.P(:, :, i-1));
if isa(EKF.Q, 'function_handle')
    Q = EKF.Q(t, Y_pred);
elseif isa(EKF.Q, 'double')
    Q = EKF.Q;
else
    error('EKF.Q must be either a constant matrix or a callable(t, Y)');
end
P_pred = Phi * EKF.P(:, :, i-1) * Phi' + Q;


end