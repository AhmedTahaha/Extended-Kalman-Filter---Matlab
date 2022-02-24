function [h, H, z] = meas_model(t, X, P, z)

h = X(1);
H = [1, 0];

end