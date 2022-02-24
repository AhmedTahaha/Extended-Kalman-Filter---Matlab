function [X, STM] = model(t0, t, X0, P0)

[~, X]  = ode45(@dynamics, [t0, t], X0);
X  = X(end, :)';

Jacobian = [0, 1; 0, 0];
STM      = eye(length(X0)) + Jacobian* (t - t0);
end

function dX = dynamics(t, X)
    dX = nan(size(X));
    dX(1) = X(2);
    dX(2) = -sin(t);
end