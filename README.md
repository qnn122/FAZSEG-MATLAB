# FAZSEG
A toolbox for Foveal Avascular Zone (FAZ) Segmentation

## Initiation
Type "FAZSEG" on the command window
```
>> FAZSEG
```
A window will appear allowing user to start using the tool's functionalities.

## Usage
1. Single image segmentation

    Segmentation -> Single Image

Output:

![Alt Text](https://media.giphy.com/media/htXd8azBvydKnWxsy3/giphy.gif)

The UI is only meant for visualization. You can turn it off in the setting. Output includes segmented mask with computed FAZ size, vessel length desity and vessel area density.

2. Multiple-image segmentation

    Segmentation -> Set of images

3. Compare similarity between mannual segmentation and automated segmentation.

    Evaluation -> Compare similarity

    Note: the input must be in the form of mask image.

4. Compute FAZ size given conversion factor:

    Compute -> FAZ -> Area


