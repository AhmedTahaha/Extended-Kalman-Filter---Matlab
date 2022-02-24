function X = groundTruth(t, X0)

x0_1 = X0(1);
x0_2 = X0(2);

validateattributes(t, {'numeric'}, {'size', [nan, 1]});

x1 = sin(t) + (1- x0_2)*t + x0_1;
x2 = cos(t) + (1 - x0_2);

X  = [x1, x2];
end

