# Extended-Kalman-Filter---Matlab
This repo implements the extended Kalman Filter class which is a multi-purpose EKF to facilitate the implementation and verification of EKFs in Matlab for the post-processing setting.

The user has to define the following functions, and then pass them to the class initializer in order to build an instant of the EKF class:
  1. $[{\bf Y}_{k}$, ${\bf \Phi}_{k-1\rightarrow k}]$ = st_model($t_{k-1}$, $t_{k}$, ${\bf Y}_{k-1}$, ${\bf P}_{k-1}$), which is a propagation function of the state vector. The output of this function must be $[{\bf Y}_{k}$, ${\bf \Phi}_{k-1\rightarrow k}]$ where ${\bf \Phi}_{k-1\rightarrow k}$ is the state transition matrix between the 
      two time instants $t_{k-1}$ and $t_{k}$
  1. $z_{k}$ = meas($t_k$) which is a function that returns the measurement vector at time $t_k$.
  1. [${\bf h}_k$, ${\bf H}_k$, ${\bf z}_k$] = meas_model($(t_{k}$, ${\bf Y}_{k}$, ${\bf z}_k$): is the measurement model function. The output must be the vector ${\bf h}_k$ of modeled measurements, the matrix H which is dh/dY, and optionally the measrement vector after removing outlaiar measuremets.
  1. Q: state model covarience matrix (constant or callable),
    Q(t, Y_pred)
  1. R: measurement covarience matrix (constant or callable),
    R(t, z)

