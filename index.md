## Weather Detection
### David Zikel

### Problem and motivation
Detection of ambient weather and climate conditions from a single image is useful in automatically categorizing images, such as on image uploading sites like Flickr. Many of these attributes can be detected through new techniques or novel applications of existing ones. This project, using various analysis methods including Retinex single-image lighting approximation, automatically categorizes images based on several ambient attributes: fog, time of day, and approximate temperature.

### Edge detection:
![Edge intensities](https://raw.githubusercontent.com/david-zikel/weather-detection/gh-pages/vision-edge.png)
The amount of fog in an image can be estimated by measuring the intensity of edges in the image. In an image with no fog, the edges should be strong, and, conversely, in an image with prevalent fog, the edges should be weak. To measure the strength of an image's edges, a modified version of a standard edge detection algorithm can be used. 

For this project, an image's edges are first detected (as a binary output, EDGE or NOT EDGE, per pixel) using the Canny edge detection algorithm. For each edge pixel detected by the Canny algorithm, the program analyzes a small (21x21) neighborhood of that edge to find the edge point in that region furthest from the original pixel. It is assumed, and this assumption has proven accurate in all analyzed images of actual scenes, that the line from the initial pixel to the found pixel is tangent to the line formed by all edge pixels.

Given this tangent line, color values are taken from two locations in the (original, color) image, both offset from the initial edge pixel in a direction perpendicular to the found tangent. This, in effect, finds the color of the image on each side of the edge being analyzed. The distance between these colors is computed (treating colors as coordinates in RGB-space), and the intensity of the edge pixel is returned as this distance.

For measuring fog, it suffices to take the average edge intensity among all pixels detected by the Canny algorithm as edges. If this average intensity is above a certain threshold, it can be assumed that there is no major fog - conversely, if the intensity is below this threshold, fog is noticeable in the image. Using this modified Canny algorithm, images had significant fog if and only if their average measured edge intensity was less than 0.2.

### Skyline detection:
![Horizon line](https://raw.githubusercontent.com/david-zikel/weather-detection/gh-pages/vision-horizon.png)
For determining the color balance of parts of an image, it is beneficial to find the location of the skyline or horizon line - the vertical position in the image marking the divide between the sky (or a very far-off part of the scene) and the objects being photographed. If the camera is aligned horizontally, this skyline will always be a horizontal line across the image. This means that, for the purposes of computation, only a y-coordinate must be found.

The 'skyline' is modeled as the point along the image (vertically) such that the image is closest in the $$L^2$$ norm to a step function on the y coordinate with its step located along the skyline. Equivalently, modeling the image as a function $$f : [0,1] \times [0,1] \rightarrow [0,1]$$, the skyline position is the value $$\hat{y}$$ such that the minimum value of

$$\int_{0}^{1} \int_{0}^{1} (f(x,y) - \mu(y))^2\,dx\,dy$$

across all functions

$$\mu(y) = \cases{\mu_u \quad y < \hat{y} \\ \mu_d \quad y \geq \hat{y}}$$

is the minimum across all step functions $$\mu$$. (For images with multiple color channels, the squared errors for each channel are summed to find the final result.) 

It is clear that the values of $$\mu_u$$ and $$\mu_d$$ minimizing this integral for a given $$\hat{y}$$ are simply the average values of the image function $$f$$ across $$y \in [0,\hat{y}]$$ and $$y \in (\hat{y},1]$$ respectively. Using these values for the outputs of $$\mu$$, $$\hat{y}$$ can be found to pixel precision by testing every value of $$y$$ corresponding to a pixel location. The computation of one such sum of squared errors per column can be done almost instantaneously, even for large images.

## Lighting data
![Retinex lighting](https://raw.githubusercontent.com/david-zikel/weather-detection/gh-pages/vision-retinex.png)

]Retinex - see cited paper.]

### Algorithm principles
Lighting approximation algorithms attempt to extract two images from one input image. These images are a *lighting* image, which contains the ambient light information for a scene, and an *albedo* image, which contains the innate reflectance information for all objects in that scene. These output images are directly and algorithm-independently linked to the input image in two ways: the first is that the lighting image is always as bright as or brighter than the input image, and the second is that the per-pixel product of the lighting and albedo images is equal to the input image.

The most prominent attribute of real lighting data, and the attribute lighting extraction algorithms most heavily rely on, is the smoothness of the lighting intensity across space. Two other properties of the lighting data are used to fine-tune the initial lighting estimate, using penalty parameters which are provided as input to the algorithm. The first property is that the lighting image should relatively closely resemble the input image, and the second property is that the albedo image (input divided by lighting) should, like the lighting image, be spatially smooth. A penalty formula is created based on these three attributes, and its solution is found using gradient descent.

### Algorithm details
All computations in the Retinex algorithm are done on the logarithm of the input image, and the output is the logarithm of the lighting image, for two reasons. The first is mathematical convenience - rather than requiring divisions for each pixel to compute the albedo image for the third penalty term, the algorithm will only use subtractions. The second reason is that a logarithmic scale more closely approximates the way humans consider lighting. For instance, the most common means of brightening an image, gamma correction, raises the intensity value for each pixel to a fixed exponent rather than using additive or multiplicative scaling.

Denoting the (logarithm of the) original image by $$S$$ and the (logarithm of the) current lighting image by $$L$$, three penalty terms are computed, corresponding to the three criteria on $$L$$ specified above:

$$\|\nabla L\|^2$$ for smoothness,

$$\alpha (L-S)^2$$ for proximity, and

$$\beta \|\nabla (L-S)\|^2$$ for albedo smoothness.

The total penalty integral over image space $$I$$, then, is $$\int \int_{I} (\|\nabla L\|^2 + \alpha (L-S)^2 + \beta \|\nabla (L-S)\|^2) \,dx \,dy$$. If is is assumed that $$\nabla S = \nabla L = 0$$ on the boundary of $$I$$, this integral simplifies to $$\int \int_{I} (L \Delta L + \alpha (L-S)^2 + \beta (L-S) \Delta (L-S)) \,dx \,dy$$, where $$\Delta$$ is the Laplacian operator $$\nabla \cdot \nabla$$.

For performance, the initial steps of the algorithm are run on smaller copies of the original image. Each copy is made from the copy of the next largest size by taking weighted averages of points at certain coordinates, approximating Gaussian weights as these averages are iterated. In the algorithm as implemented, 40 percent of gradient descent iterations are run on an image 1/64 the size of the original input (1/8 scale along both axes), 30 percent on an image 1/16 the size, 20 percent on an image 1/4 the size, and only 10% of iterations on the original input. As, due to the smoothness requirement, the most important attributes of the lighting image are its large-scale properties, this process greatly speeds up convergence.

### Implementation specifics
]maybe merge into above]

### Data aggregation
]Move fog<.8 here?]

### Proposal and midterm report
Proposal: [Link](https://github.com/david-zikel/weather-detection/raw/gh-pages/766%20Project%20Proposal.pdf)

Midterm report: [Link](https://github.com/david-zikel/weather-detection/raw/gh-pages/766%20Project%20Midterm%20Report.pdf)

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
