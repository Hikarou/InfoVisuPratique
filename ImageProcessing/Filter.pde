PImage brightnessThreshold(PImage img, int threshold) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    int p = img.pixels[i]; float b = brightness(p); 
    if(b > threshold) result.pixels[i] = color(255);    
    else result.pixels[i] = color(0); 
  }
  return result;
}


PImage hueThreshold (PImage img, float minHue, float maxHue) {
  PImage result = createImage(img.width, img.height, ALPHA);
  for (int i = 0; i < img.width * img.height; i++) {
      int p = img.pixels[i]; float h = hue(p); 
      
      if (h < minHue || h > maxHue) result.pixels[i] = color(0);
      else result.pixels[i] = color(255);
  }
  return result;
}