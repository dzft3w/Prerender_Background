# Prerender_Background
A unity scene trying to use prerender image as background. It tries to recreate graphics similar to old games such as resident evil or final fantasy in the 90s. Using depth buffer from rendered images to map the distance of objects, and decide whether an object is blocked by "foreground" or not.

ref:
https://github.com/SpookyFM/DepthCompositing

created using ver. 2019.3.11f

problems:

1. Object distance doesn't match with render image. (Maybe caused by nonlinear depth map image and camera clip planes)
2. Creates image artifacts when pixel shifting. This is trying to create 3D photo effect, like facebook 3D photos. But with a worse algorithm.
