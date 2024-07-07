# Extended-Kalman-Filter---Matlab
This repo implements the extended Kalman Filter class which is a multi-purpose EKF to facilitate the implementation and verification of EKFs in Matlab for the post-processing setting.

The user has to define the following functions, and then pass them to the class initializer in order to build an instant of the EKF class:
  1. $`[\pmb{y}_{k|k-1},\pmb{\Phi}_{k-1\rightarrow k}]`$  = $`\text{st\_model}(t_{k-1}, t_{k}, \pmb{y}_{k-1|k-1}, \pmb{P}_{k-1|k-1})`$, which is a propagation function of the state vector. The output of this function must be $`\pmb{y}_{k|k-1}`$, the predicted value of the state vector, and $`\pmb{\Phi}_{k-1\rightarrow k}`$ where $`\pmb{\Phi}_{k-1\rightarrow k}`$ is the state transition matrix between the two time instants $`t_{k-1}`$ and $`t_{k}`$
  1. $`\pmb{z}_{k}`$ = $`\text{meas}(t_k)`$ which is a function that returns the measurement vector at time $`t_k`$.
  1. $`[\pmb{H}_k, \pmb{H}_k, \pmb{z}_k]`$ = $`\text{meas\_model}(t_{k}, \pmb{y}_{k|k-1}, \pmb{z}_k)`$: is the measurement model function. The output must be the vector $`\pmb{H}_k`$ of modeled measurements, the matrix $`\pmb{H}_k = \frac{\partial \pmb{H}_k}{\partial \pmb{y}_k}`$, and optionally the measrement vector after removing outlaiar measuremets.
  1. $`\pmb{Q}_{k}`$, the state model covarience matrix (constant or callable), $`\pmb{Q}(t_{k}, \pmb{y}_{k|k-1})`$
  1. $`\pmb{R}_{k}`$: measurement covarience matrix (constant or callable),
    $`\pmb{R}(t_{k}, \pmb{z}_{k})`$

  The EKF class has some visualization cababilities, which are illustrated in the example.
  
  [![View Extended-Kalman-Filter---Matlab on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/107410-extended-kalman-filter-matlab)
