---
layout: cv
permalink: /cv/
title: cv
nav: true
nav_order: 4
cv_pdf: Isabel_MacGinnitie_CV.pdf # you can also use external links here
description: Last updated 12/11/2025
---

<div style="width: 100%; height: 800px;">
  <iframe 
    src="{% if page.cv_pdf contains '://' %}{{ page.cv_pdf }}{% else %}{{ page.cv_pdf | prepend: '/assets/pdf/' | relative_url }}{% endif %}#toolbar=1&navpanes=1&scrollbar=1" 
    width="100%" 
    height="100%" 
    style="border: none;">
    <p>Your browser does not support PDFs. 
      <a href="{% if page.cv_pdf contains '://' %}{{ page.cv_pdf }}{% else %}{{ page.cv_pdf | prepend: '/assets/pdf/' | relative_url }}{% endif %}" target="_blank">Download the PDF</a>.
    </p>
  </iframe>
</div>
