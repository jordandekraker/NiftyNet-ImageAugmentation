# NiftyNet-ImageAugmentation
Code, slides, and examples of how to use augment image segmetnation/classification deep learning problems using the method described by Uzonova et al. (2017).

Note in this implementation my model-based augmentation is based on ANTs label-label registration, rather than on RegNet.

# Dependencies
- https://github.com/yinglilu/deeplearning_gpu_singularity (for NiftyNet, HPC configuration, and generally helpful tools)
- https://github.com/khanlab/neuroglia-helpers (for job submission management in HPC clusters)
- http://stnava.github.io/ANTs/ (for image registration)


Uzunova, Hristina, Matthias Wilms, Heinz Handels, and Jan Ehrhardt. "Training CNNs for image registration from few samples with model-based data augmentation." In International Conference on Medical Image Computing and Computer-Assisted Intervention, pp. 223-231. Springer, Cham, 2017.
