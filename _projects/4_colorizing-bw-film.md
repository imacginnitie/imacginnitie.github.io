---
layout: page
title: colorizing b&w film
description: Computational Photography II 2022
img: assets/img/projects/colorizing/aligned.jpg
importance: 4
category: fun
permalink: projects/colorizing-bw-film/
---

#### Comparing the Prokudin-Gorskii Method and Neural Networks

[Full written report](../../assets/pdf/MacGinnitie_Final_Project_Report.pdf)

<div class="row align-items-center justify-content-center">
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/2bw.jpg" title="black and white film" caption="black and white film" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/2_pg.jpg" title="PG method" caption="PG method" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-3 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/film_img_8.png" title="CNN colorized" caption="CNN colorized" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
This project compared modern machine learning colorization with a 1900s Russian technique for colorizing analog photographs. I trained a convolutional neural network colorizer, customizing it for my use-case by experimenting with the relationship between training data composition and colorization results for the nine custom-made and 100 historical images chosen for testing.

Following the Prokudin-Gorskii method, I took three exposures of the same scene with a translucent red, green, then blue filter over the camera lens. The filter absorbs the light of the opposite wavelength, so light with the complimentary color will not reach the film, and thus not cause it to darken. I then used the scans of these three exposures as the red, green, and blue channels of an RGB image.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/red_filter.jpg" title="red filter" caption="red filter" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/green_filter.jpg" title="green filter" caption="green filter" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/blue_filter.jpg" title="blue filter" caption="blue filter" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/red_channel.jpg" title="red channel" caption="red channel" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/green_channel.jpg" title="green channel" caption="green channel" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/blue_channel.jpg" title="blue channel" caption="blue channel" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="row justify-content-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/aligned.jpg" title="Final result of PG method" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Final result of Prokudin-Gorskii method
</div>

For the ML approach, I adapted Emil Wallner's "How to colorize black & white photos with just 100 lines of neural network code" CNN tutorial's full version, which incorporated a pre-trained classifier Inception ResNet v2 with the CNN. For my dataset, I combined Wallner's Unsplash (misc), Nvidia's StyleGAN (faces), and Stanford DAGS Lab's Stanford Background Dataset (greenery). I trained my full final model on 15,007 images, divided into five sets of 3,000 (with the batch #5 being 3,007). For each set, I trained the model for 50 epochs, which each ran on batches of 30 images for 100 steps.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/ex1.png" title="example 1" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/ex2.png" title="example 2" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/ex3.png" title="example 3" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

#### Example Images

Andy

<div class="row">
    <div class="col-sm-6 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/andy_digital.jpg" title="digital"  caption="digital" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-6 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/andy_film.jpg" title="black and white film"  caption="black and white film" class="img-fluid rounded z-depth-1" %}
    </div>

</div>
<div class="row align-items-center">
    <div class="col-sm-7 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/andy_aligned.jpg" title="Prokudin-Gorskii method" caption="Prokudin-Gorskii method" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-5 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/film_img_3.png" title="CNN colorized" caption="CNN colorized" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
Eugene
<div class="row">
    <div class="col-sm-6 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/eugene_digital.jpg" title="digital"  caption="digital" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-6 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/eugene_film.jpg" title="black and white film"  caption="black and white film" class="img-fluid rounded z-depth-1" %}
    </div>

</div>
<div class="row align-items-center">
    <div class="col-sm-7 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/eugene_aligned.jpg" title="Prokudin-Gorskii method" caption="Prokudin-Gorskii method" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-5 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/projects/colorizing/film_img_1.png" title="CNN colorized" caption="CNN colorized" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
