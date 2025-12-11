---
layout: page
title: building an intuitive image complexity metric
description: A novel approach to measuring image complexity using decompression instructions
img: assets/img/projects/image_complexity/image compression profiling summer research poster.png
importance: 11
category: work
---

One of the fundamental challenges in computer vision is quantifying image complexity in a way that matches human intuition. Bennett's theory of logical depth outlines a way to measure intuitive image complexity [1], but it's computationally impossible to calculate. Previous attempts to approximate it have measured program execution timing, which is inherently noisy [2].

This research project developed a novel, reproducible approach to measuring image complexity by analyzing decompression instructions. By generating and testing over 68,000 binary images with carefully controlled complexity trends, I discovered that combining LZ77 compression with Callgrind instruction counting provided the most reliable approximation of intuitive complexity. Despite PNG achieving better compression ratios, this approach is better aligned with qualitative complexity measurements than maximally optimized PNG compression (pngcrush brute force). It's also faster, simpler to implement, and easier to extend to filetypes beyond images.

These findings have potential applications in improving AI image generation systems by providing better complexity weighting, and could be applied to individual image features to measure relative saliency.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/image_complexity/image compression profiling summer research poster.png" title="research poster" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Research poster summarizing the image complexity metric approach
</div>

## References

[1] C. H. Bennett, "Logical Depth and Physical Complexity," in The Universal Turing Machine: A Half-Century Survey, R. Herken, Ed. Oxford University Press, 1988.

[2] H. Zenil, J.-P. Delahaye, and C. Gaucherel, "Image characterization and classification by physical complexity," Complexity, vol. 17, no. 3, pp. 26-42, 2012.

