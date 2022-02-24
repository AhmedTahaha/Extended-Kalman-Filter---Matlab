function [sigma_est] = show_patch_states(P, x_vec, y_vec, clr)

if nargin< 4
    clr = 'None';
end

Pi        = squeeze(P);
P_        = mean(Pi);
Pi(Pi<0)  = P_;
sigma_est = sqrt(Pi)';

ubounds   = y_vec + 3*sigma_est;
lbounds   = y_vec - 3*sigma_est;
x_vec_ul  = [x_vec, fliplr(x_vec)];
ul = [ubounds, fliplr(lbounds)];

gca;
hold on;
patch(x_vec_ul, ul, [0.5, 0.5, 0.5],'FaceAlpha', 0.5, 'EdgeColor', clr);

end