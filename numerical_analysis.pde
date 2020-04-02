/*
  Resources
  */
Differentiable fn = new Differentiable() {
  public double fx(double x)
  {
    return x*(1-x)*(1-x)+0.5;
  }
  
  public double dfdx(double x)
  {
    return (1-x)*(1-x)-2*x*(1-x);
  }
};
double err = 1e-8;
BisectionSolver bisection = new BisectionSolver(fn, err);
NewtonSolver newton = new NewtonSolver(fn, err);
SecantSolver secant = new SecantSolver(fn, err);
RegularFalsiSolver falsi = new RegularFalsiSolver(fn, err);

/*
  Rendering Information
*/
double p0 = -0.5;
double p1 = 0.9;
double xmin = -1;
double xmax = 1;
double xres = 0.01;
double ymin = -1;
double ymax = -ymin;
boolean t0 = true;
boolean t1 = true;
boolean t2 = true;
boolean t3 = true;


void setup()
{
  size(720, 360);
  colorMode(HSB, 1);
  background(0);
  
  // Initialize
  bisection.initialize(p0, p1);
  newton.initialize(p0);
  secant.initialize(p0, p1);
  falsi.initialize(p0, p1);
  
  // Plot
  stroke(0.5);
  line(0, height/2, width/2, height/2);
  stroke(1);
  double px = xmin;
  double py = fn.fx(px);
  for (double x = px + xres; x <= xmax; x += xres)
  {
    double y = fn.fx(x);
    line(map((float)x, (float)xmin, (float)xmax, 0, width/2),
      map((float)y, (float)ymin, (float)ymax, height, 0),
      map((float)px, (float)xmin, (float)xmax, 0, width/2),
      map((float)py, (float)ymin, (float)ymax, height, 0));
    px = x;
    py = y;
  }
  
  int N = 8;
  for (int n = 0; n < N; ++n)
  {
    if(t0)
    {
      bisection.iterate();
      plot(bisection.p, 0.0, color(0, 1, 1));
      plot2(n, N, bisection.p, color(0, 1, 1));
    }
    if(t1)
    {
      newton.iterate();
      plot(newton.p, 0.0, color(0.4, 1, 1));
      plot2(n, N, newton.p, color(0.4, 1, 1));
    }
    if(t2)
    {
      plotLine(secant.p0, fn.fx(secant.p0), secant.p1, fn.fx(secant.p1), color(0.6, 1, 1));
      secant.iterate();
      plot(secant.p, 0.0, color(0.6, 1, 1));
      plot2(n, N, secant.p, color(0.6, 1, 1));
    }
    if(t3)
    {
      plotLine(falsi.p0, fn.fx(falsi.p0), falsi.p1, fn.fx(falsi.p1), color(0.8, 1, 1));
      falsi.iterate();
      plot(falsi.p, 0.0, color(0.8, 1, 1));
      plot2(n, N, falsi.p, color(0.8, 1, 1));
    }
  }
  
  // Convergence graph
}

void draw()
{
}

void plot(double x, double y, color c)
{
  stroke(c);
  float px = map((float)x, (float)xmin, (float)xmax, 0, width/2);
  float py = map((float)y, (float)ymin, (float)ymax, height, 0);
  line(px-5, py-5, px+5, py+5);
  line(px+5, py-5, px-5, py+5);
}

void plotLine(double x, double y, double x2, double y2, color c)
{
  stroke(c);
  float px = map((float)x, (float)xmin, (float)xmax, 0, width/2);
  float py = map((float)y, (float)ymin, (float)ymax, height, 0);
  float qx = map((float)x2, (float)xmin, (float)xmax, 0, width/2);
  float qy = map((float)y2, (float)ymin, (float)ymax, height, 0);
  line(px, py, qx, qy);
}

void plot2(int n, int N, double x, color c)
{
  //stroke(c);
  fill(c);
  noStroke();
  float px = map(n, 0, N, width/2, width);
  float py = map((float)x, (float)xmin, (float)xmax, height, 0);
  //line(px-5, py-5, px+5, py+5);
  //line(px+5, py-5, px-5, py+5);
  ellipse(px, py, 4, 4);
}