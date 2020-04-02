interface Continuous
{
  public double fx(double x);
}

interface Differentiable extends Continuous
{
  public double dfdx(double x);
}

/**
  Implementation of Bisection algorithm.
*/
class BisectionSolver
{
  public Continuous fn;
  public double a, b, p, epsilon, fa, fp;
  
  public BisectionSolver(Continuous fn, double epsilon)
  {
    this.fn = fn;
    this.epsilon = epsilon;
  }
  
  public void initialize(double a, double b)
  {
    this.a = a;
    this.b = b;
    this.fa = fn.fx(a);
  }
  
  /**
    If iterate one step, sequence proceed to next entry.
    It returns true if sequence converges sufficiently
    to given accuracy.
  */
  public boolean iterate()
  {
    double e = (b - a) / 2.0;
    p = a + e;
    fp = fn.fx(p);
    if (e < epsilon || fp == 0.0)
      return true;
    else if (fa * fp < 0)
    {
      b = p;
    }
    else
    {
      a = p;
      fa = fp;
    }
    return false;
  }
}

/**
  Implementation of Newton's Method
*/
class NewtonSolver
{
  public Differentiable fn;
  public double p0, p, epsilon;
  
  public NewtonSolver(Differentiable fn, double epsilon)
  {
    this.fn = fn;
    this.epsilon = epsilon;
  }
  
  public void initialize(double p0)
  {
    this.p0 = p0;
  }
  
  public boolean iterate()
  {
    double e = fn.fx(p0) / fn.dfdx(p0);
    p = p0 - e;
    if (Math.abs(e) < epsilon)
      return true;
    p0 = p;
    return false;
  }
}

/**
  Implementation of Secant's Method
*/
class SecantSolver
{
  public Continuous fn;
  public double p0, p1, p, epsilon, fp0, fp1;
  
  public SecantSolver(Continuous fn, double epsilon)
  {
    this.fn = fn;
    this.epsilon = epsilon;
  }
  
  public void initialize(double p0, double p1)
  {
    this.p0 = p0;
    this.p1 = p1;
    fp0 = fn.fx(p0);
    fp1 = fn.fx(p1);
  }
  
  public boolean iterate()
  {
    double e = fp1 * (p1 - p0) / (fp1 - fp0);
    p = p1 - e;
    if (Math.abs(e) < epsilon)
      return true;
    p0 = p1;
    fp0 = fp1;
    p1 = p;
    fp1 = fn.fx(p);
    return false;
  }
}

/**
  Implementation of Regular Falsi Method
*/
class RegularFalsiSolver
{
  public Continuous fn;
  public double p0, p1, p, epsilon, fp0, fp1;
  
  public RegularFalsiSolver(Continuous fn, double epsilon)
  {
    this.fn = fn;
    this.epsilon = epsilon;
  }
  
  /**
    f(p0) * f(p1) < 0 must be satisfied.
  */
  public void initialize(double p0, double p1)
  {
    this.p0 = p0;
    this.p1 = p1;
    fp0 = fn.fx(p0);
    fp1 = fn.fx(p1);
    if (fp0 * fp1 > 0.0)
      throw new IllegalArgumentException("f(p0) * f(p1) < 0");
  }
  
  public boolean iterate()
  {
    double e = fp1 * (p1 - p0) / (fp1 - fp0);
    p = p1 - e;
    if (Math.abs(e) < epsilon)
      return true;
    double fp = fn.fx(p);
    if (fp * fp1 < 0.0)
    {
      p0 = p1;
      fp0 = fp1;
    }
    p1 = p;
    fp1 = fp;
    return false;
  }
}