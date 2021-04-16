## Weather Detection
### David Zikel

### Introduction
Weather detection program. Uses various image processing techniques, most notably retinex lighting information (https://www.cs.technion.ac.il/~ron/PAPERS/retinex_ijcv2003.pdf). More information to be included.

### Edge detection:
Use Canny algorithm,
estimate direction from edge pixels ~5px away,
and set intensity based on checks offset by a value perpendicular to this direction.

### Skyline detection:
Find y-value s.t. the squared difference between two 'means' shifting at that value is minimized.
Formula can be included here verbatim.
$$ \int_{0}^{1} \int_{0}^{1} (f(x,y) - \mu(y))\,dx $$

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
