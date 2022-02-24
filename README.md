# Extended-Kalman-Filter---Matlab
The Extended Kalman Filter class is designed to facilitate the implementation of EKF in Matlab.

The used has to define the following functions, and then pass them to the class initializer:
1. st_model($t_{k-1}$, $t_{k}$, $Y_{k-1}$, $P_{k-1}$)



  - [Y(k), STM] = st_model(t(k-1), t(k), Y(k-1), P(k-1)): is 
    a propagating function. The output of this function must
    be [Y(t), STM] where STM is the state transition matrix between the 
    two time instants (t(k-1)) and (t(k))
  - z = meas(t): a function that returns the measurement vector at time 
    t(k).
  - [h, H, z] = meas_model(t,Y, z): is the measurement model 
    function. The output must be the vector h of modeled 
    measurements, the matrix H which is dh/dY, and optionally
    the measrement vector after removing outlaiar measuremets.
  - Q: state model covarience matrix (constant or callable),
    Q(t, Y_pred)
  - R: measurement covarience matrix (constant or callable),
    Q(t, Y_pred)

