function z = meas(t, Y_GT, t_vec)

z = Y_GT(t==t_vec, 1) + normrnd(0, 0.1);

end
