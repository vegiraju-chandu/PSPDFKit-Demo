#@codekit-prepend "aw_slideshow.coffee";

$(window).load -> 
  window.CaseStudies = new AWSlideshow("section.case-studies", { fadeElement: ".description" }) 