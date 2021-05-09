class Ring {
  int pointAmount, currentlyDrawing;  
  PVector[] origin, end;
  float innerRadius, outerRadius;
  float[] str;
  float outerNoise = 7.0;
  float outerNoiseScale = 4.5;
  float strNoiseScale = 5.0;
  float fluffFactor = 0.075;
  float gaussianFactor = 0.175;
  float strNoiseF = 0.8;
  color mono1 = color(20), mono2 = (255);

  Ring(float x, float y, float inner, float outer, int _pointAmount)
  {
    innerRadius = inner;
    outerRadius = outer;
    currentlyDrawing = 0;

    pointAmount = _pointAmount;

    origin = new PVector[pointAmount];
    end = new PVector[pointAmount];
    str = new float[pointAmount];

    float angleInc = TWO_PI/pointAmount;

    CircularNoise circularNoise1 = new CircularNoise(2.0);
    CircularNoise circularNoise2 = new CircularNoise(outerNoiseScale);
    CircularNoise strNoise = new CircularNoise(strNoiseScale);

    for (int i = 0; i < pointAmount; i++)
    {
      float rd = innerRadius + 1 * circularNoise1.getNoise(angleInc * i);
      float px = x + cos(angleInc * i) * rd;
      float py = y + sin(angleInc * i) * rd;
      origin[i] = new PVector(px, py);
      str[i] = strNoise.getNoise(angleInc * i);
    }

    for (int i = 0; i < pointAmount; i++)
    {
      float fluff = random(-fluffFactor, fluffFactor);
      float rd = innerRadius + (outerRadius - innerRadius) * (1 - circularNoise2.getNoise((angleInc * i)) * outerNoise);
      float px = x + cos(angleInc * i + fluff) * rd;
      float py = y + sin(angleInc * i + fluff) * rd;
      end[i] = new PVector(px, py);
    }
  }

  Ring(Ring other) {
    currentlyDrawing = 0;

    pointAmount = other.pointAmount;

    origin = other.end;
    end = new PVector[pointAmount];
    str = new float[pointAmount];

    float angleInc = TWO_PI/pointAmount;
    float d = (other.outerRadius - other.innerRadius);
    innerRadius = other.outerRadius;
    outerRadius = other.outerRadius + d;
    CircularNoise circularNoise2 = new CircularNoise(outerNoiseScale);
    CircularNoise strNoise = new CircularNoise(strNoiseScale);

    for (int i = 0; i < pointAmount; i++) {
      float fluff = random(-fluffFactor, fluffFactor);
      float rd = innerRadius + (outerRadius - innerRadius) * (1 - circularNoise2.getNoise((angleInc*i)) * outerNoise);
      float px = origin[i].x + cos(angleInc * i + fluff) * rd;
      float py = origin[i].y + sin(angleInc * i + fluff) * rd;
      end[i] = new PVector(px, py);
      str[i] = strNoise.getNoise(angleInc * i) * strNoiseF;
    }
  }

  void draw()
  {
    if (currentlyDrawing < pointAmount)
    {
      PVector originA = origin[currentlyDrawing];
      PVector endA = end[currentlyDrawing];
      PVector originB = currentlyDrawing == 0 ? origin[origin.length-1] : origin[currentlyDrawing-1];
      PVector endB = currentlyDrawing == 0 ? end[end.length-1] : end[currentlyDrawing-1];

      int points = outerRadius < 10 ? 30 : round(outerRadius * 3);
      
      drawRect(originA, endA, originB, endB, points);
      drawRect2(originA, endA, originB, endB, points);
      currentlyDrawing++;
    }
  }

  void drawLine(float x, float y, float x2, float y2, int points)
  {    
    float w = str[currentlyDrawing] / points;

    for (int i = 0; i < points; i++) {
      float alpha = 0.1 - i / (points * 10.0);

      stroke(mono1, 16 + alpha * 128);
      point(x + (x2-x) * (sin(i*w)), y + (y2-y) * (sin(i*w)));
    }
  }

  void drawRect(PVector originA, PVector endA, PVector originB, PVector endB, int points)
  {
    float w = str[currentlyDrawing] * 3 / points;
    
    float minOriginX = min(originA.x, originB.x);
    float minOriginY = min(originA.y, originB.y);
    float minEndX = min(endA.x, endB.x);
    float minEndY = min(endA.y, endB.y);
    
    float maxOriginX = max(originA.x, originB.x);
    float maxOriginY = max(originA.y, originB.y);
    float maxEndX = max(endA.x, endB.x);
    float maxEndY = max(endA.y, endB.y);
    
    for (int i = 0; i < points; i++) {
      float x = random(minOriginX, maxOriginX);
      float y = random(minOriginY, maxOriginY);
      float x2 = random(minEndX, maxEndX);
      float y2 = random(minEndY, maxEndY);
      
      float alpha = 0.1 - i / (points * 10.0);

      stroke(mono1, 48 + alpha * 128);
      point(x + (x2-x) * (sin(i*w)), y + (y2-y) * (sin(i*w)));
    }
  }
  
  void drawRect2(PVector originA, PVector endA, PVector originB, PVector endB, int points)
  {    
    float minOriginX = min(originA.x, originB.x);
    float minOriginY = min(originA.y, originB.y);
    float minEndX = min(endA.x, endB.x);
    float minEndY = min(endA.y, endB.y);
    
    float maxOriginX = max(originA.x, originB.x);
    float maxOriginY = max(originA.y, originB.y);
    float maxEndX = max(endA.x, endB.x);
    float maxEndY = max(endA.y, endB.y);
    
    for (int i = 0; i < points; i++) {
      float x = random(minOriginX, maxOriginX);
      float y = random(minOriginY, maxOriginY);
      float x2 = random(minEndX, maxEndX);
      float y2 = random(minEndY, maxEndY);
      
      float alpha = 0.1 - i / (points * 10.0);
      
      float r = abs(randomGaussian() * gaussianFactor);
      float r2 = 1 - abs(randomGaussian() * 0.15);
      
      stroke(mono1, 48 + alpha * 196);
      point(x + (x2-x) * r, y + (y2-y) * r);
      /*
      stroke(mono2, 16 + alpha * 125);
      point(x + (x2-x) * r2, y + (y2-y) * r2);*/
    }
  }
}
