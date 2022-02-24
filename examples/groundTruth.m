function X = groundTruth(t, X0)

x0_1 = X0(1);
x0_2 = X0(2);

validateattributes(t, {'numeric'}, {'size', [nan, 1]});

rnd_vel = normrnd(0, 0.02);
x1 = sin(t) + (1- x0_2)*t + x0_1 + rnd_vel*t;
x2 = cos(t) + (1 - x0_2) + rnd_vel;

X  = [x1, x2];
end

