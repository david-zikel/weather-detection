## Weather Detection
### David Zikel

### Introduction
Weather detection program. Uses various image processing techniques, most notably retinex lighting information (https://www.cs.technion.ac.il/~ron/PAPERS/retinex_ijcv2003.pdf). More information to be included.

### Edge detection:
Use Canny algorithm,

estimate direction from edge pixels ~5px away,

and set intensity based on checks offset by a value perpendicular to this direction.

### Skyline detection:
For determining the color balance of parts of an image, it is beneficial to find the location of the skyline or horizon line - the vertical position in the image marking the divide between the sky (or a very far-off part of the scene) and the objects being photographed. If the camera is aligned horizontally, this skyline will always be a horizontal line across the image. This means that, for the purposes of computation, only a y-coordinate must be found.

The 'skyline' is modeled as the point along the image (vertically) such that the image is closest in the $$L^2$$ norm to a step function on the y coordinate with its step located along the skyline. Equivalently, modeling the image as a function $$f : [0,1] \times [0,1] \rightarrow [0,1]$$, the skyline position is the value $\hat{y}$ such that the minimum value of

$$\int_{0}^{1} \int_{0}^{1} (f(x,y) - \mu(y))^2\,dx\,dy$$

across all functions

$$\mu(y) = \cases{\mu_u \quad y < \hat{y} \\ \mu_d \quad y \geq \hat{y}}$$

is the minimum across all step functions $$\mu$$. (For images with multiple color channels, the squared errors for each channel are summed to find the final result.) 

It is clear that the values of $$\mu_u$$ and $$\mu_d$$ minimizing this integral for a given $$\hat{y}$$ are simply the average values of the image function $$f$$ across $$y \in [0,\hat{y}]$$ and $$y \in (\hat{y},1]$$ respectively. Using these values for the outputs of $$\mu$$, $$\hat{y}$$ can be found to pixel precision by testing every value of $$y$$ corresponding to a pixel location. The computation of one such sum of squared errors per column can be done almost instantaneously, even for large images. [Include a picture of a found horizon line for a real image? For test data?]

## Lighting data
Retinex - see cited paper.
### Algorithm principles
### Algorithm details
### Implementation specifics

### Markdown

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).
