# Quantum_Tomography_and_Bell_Inequality
This project reconstructs entangled quantum states and visualizes them with density matrices, demonstrating photon pulse entanglement in polarization. MATLAB scripts are used to compute the density matrix and verify quantum behavior through Bell's Inequality, with statistical analysis and visualization.
## Process Real Data: define_camera_gary.m
Connects to the computer and controls four cameras used in the experiment setup for Alice and Bob, capturing data from each camera to record photon detections and intensities.
## Customize Pixels: Customize_Frames_Pixels.m
Processes each video to identify the specific pixel regions relevant to that video, ensuring the capture of maximal intensity for accurate measurement and analysis. In the tomography process, four distinct pixel regions are selected corresponding to Alice-V, Alice-H, Bob-V, and Bob-H. For Bell's test, the script identifies two sets of pixels, capturing the maximum intensity for Alice and Bob.
## Simulate Photon Pulses: gen_random_pulses_to_CVC.m
## Reconstruct Density Matrix: Quantum_Tomography_Density_Matrix_Complete.m
## Run Simulations: Quantum_Tomography_Density_Matrix_Simulation.m
## Showw all 16 angles together : Visualize_All_Videos_Together.m
## Test Bell's Inequality: Bells_Test.m
