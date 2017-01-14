# MonoDepthCNN
A sample take on the CNN based approach to find the depth map of a monocular image.

datasolver.m
It preprocesses the RAW NYUV2 dataset across different classes. The order of execution according to what I have done of the matlab script is given below. The mentioned matlab scripts are available freely under NYUV2-dataset-toolbox. 

1. Get the matched depth and rgb images using get_synched_frames.m
2. After obtaining the images, apply project_depth_map.m . It aligns the depth map onto the rgb image.
3. crop_image.m to select only those portions of the image which have valid depth data.
4. fill_depth_cross_bf.m to fill the missing depth values which incorporates cross bilateral filter...
