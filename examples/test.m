clc; clear; close all;

%% Filter configuration
savePics = false; 
waitbar  = true;
n_states = 2;
Q  = diag([0, 0.02^2]);
R  = 0.1^2;

%% Filter initiation
t_vec = linspace(0, 30, 1e3)';
X_GT  = groundTruth(t_vec, [0; 1]);
X0    = rand(2, 1);
P0    = diag([1, 1]);


ekf = EKF(n_states, @(t0, t, Y0, P0) model(t0, t, Y0, P0),...
          @(t, Y, P, z) meas_model(t, Y, P, z),...
          @(t) meas(t, X_GT, t_vec), Q, R);
ekf.Y_GT    = X_GT';
ekf.waitbar = waitbar;

%% Estimation
ekf.estimate(t_vec, X0, P0);


%% Visualization
opts = {'OneAxis', false, 'showpatch', true, 'ylabel', {'$\Delta$ Position', '$\Delta$ Velocity'}, 'ylim', []};
ekf.plot_err(1:2, t_vec, opts, '*', 'MarkerSize', 5);
if savePics
    print('./postProcessing/Error', '-dpng');
end

opts = {'OneAxis', true, 'legend', {'Position', 'Velocity'}, 'ylim', [], 'pltGT', true};
ekf.plot_states(1:2, t_vec, opts, 'LineWidth', 1.5)
if savePics
    print('./postProcessing/States', '-dpng');
end

opts = {'OneAxis', false, 'ylabel', {'$\sigma_{pos}$', '$\sigma_{vel}$'}, 'ylim', []};
ekf.plot_est_sd(1:2, t_vec, opts, '.')
if savePics
    print('./postProcessing/StanderdDeviation', '-dpng');
end

opts = {'ylabel', {'Custom'}, 'ylim', [-5, 5]};
ekf.plot_custom(@custom_fun, t_vec, opts, '-r', 'LineWidth', 1.5)
if savePics
    print('./postProcessing/CustomFunction', '-dpng');
end

function out = custom_fun(obj)
    out = obj.Y(1, :) + obj.Y(2, :);
end