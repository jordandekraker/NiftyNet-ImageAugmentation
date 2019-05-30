# NiftyNet-ImageAugmentation
Code, slides, and examples of how to use augment image segmetnation/classification deep learning problems using the method described by Uzonova et al. (2017).

This code is meant to be used as a minimalist example for how to apply the principles to new data. See NotesOnMyImplementation.txt for instructions on how to step through these scripts. Data are not provided (far too large), so the code cannot be run out-of-the-box.

Note: in this implementation, model-based augmentation is based on ANTs label-label registration, rather than on RegNet as in the above reference. Within-class image-image registration could also be used for classification & regression problems IF image components are continuous (see slides).

# Dependencies
- https://github.com/yinglilu/deeplearning_gpu_singularity (for NiftyNet and generally helpful tools on HPC clusters)
- https://github.com/khanlab/neuroglia-helpers (for job submission management in HPC clusters)
- http://stnava.github.io/ANTs/ (for image registration)


Uzunova, Hristina, Matthias Wilms, Heinz Handels, and Jan Ehrhardt. "Training CNNs for image registration from few samples with model-based data augmentation." In International Conference on Medical Image Computing and Computer-Assisted Intervention, pp. 223-231. Springer, Cham, 2017.
