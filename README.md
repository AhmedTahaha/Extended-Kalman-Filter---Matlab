# Extended-Kalman-Filter---Matlab
This repo implements the extended Kalman Filter class which is a multi-purpose EKF to facilitate the implementation and verification of EKFs in Matlab for the post-processing setting.

The user has to define the following functions, and then pass them to the class initializer in order to build an instant of the EKF class:
  1. $[{\bf y}_{k|k-1}$, ${\bf \Phi}_{k-1\rightarrow k}]$ = ST_MODEL($t_{k-1}$, $t_{k}$, ${\bf y}_{k-1|k-1}$, ${\bf P}_{k-1|k-1}$), which is a propagation function of the state vector. The output of this function must be $[{\bf y}_{k|k-1}$, the predicted value of the state vector, and ${\bf \Phi}_{k-1\rightarrow k}]$ where ${\bf \Phi}_{k-1\rightarrow k}$ is the state transition matrix between the two time instants $t_{k-1}$ and $t_{k}$
  1. $z_{k}$ = MEAS($t_k$) which is a function that returns the measurement vector at time $t_k$.
  1. [${\bf h}_k$, ${\bf H}_k$, ${\bf z}_k$] = MEAS_MODEL($(t_{k}$, ${\bf y}_{k|k-1}$, ${\bf z}_k$): is the measurement model function. The output must be the vector ${\bf h}_k$ of modeled measurements, the matrix ${\bf H}_k$ which is $\frac{\partial {\bf h}_k}{\partial {\bf y}_k}$, and optionally the measrement vector after removing outlaiar measuremets.
  1. ${\bf Q}_{k}$, the state model covarience matrix (constant or callable), ${\bf Q}$($t_{k}$, ${\bf y}_{k|k-1}$)
  1. ${\bf R}_{k}$: measurement covarience matrix (constant or callable),
    ${\bf R}$($t_{k}$, ${\bf z}_{k}$)

  The EKF class has some visualization cababilities, which are illustrated in the example.