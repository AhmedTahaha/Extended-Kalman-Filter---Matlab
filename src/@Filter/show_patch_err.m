function [sigma_est] = show_patch_err(P, x_vec, ptch)

Pi    = squeeze(P);
P_        = mean(Pi);
Pi(Pi<0)  = P_;
sigma_est = sqrt(Pi)';

if ptch
    ubounds   = 3*sigma_est;
    lbounds   = -3*sigma_est;
    x_vec_ul  = [x_vec, fliplr(x_vec)];
    ul = [ubounds, fliplr(lbounds)];

    gca;
    hold on;
    patch(x_vec_ul, ul, [0.5, 0.5, 0.5],'FaceAlpha', 0.5, 'EdgeColor', 'none');
end

end