class CircularNoise
{
  float offsetX, offsetY, offsetZ;
  float scale;

  CircularNoise(float scale)
  {
    offsetX = random(100000);
    offsetY = random(100000);
    offsetZ = random(100000);
    
    this.scale = scale;
  }

  float getNoise(float radian)
  {
    float r = radian % TWO_PI;
    
    if (r < 0.0)
      r += TWO_PI;
      
    return noise(offsetX + cos(r) * scale, offsetY + sin(r) * scale);
  }
  
  float getNoise(float radian, float time)
  {
    float r = radian % TWO_PI;
    
    if (r < 0.0)
      r += TWO_PI;
    
    return noise(offsetX + cos(r) * scale, offsetY + sin(r) * scale, offsetZ + time);
  }
}
