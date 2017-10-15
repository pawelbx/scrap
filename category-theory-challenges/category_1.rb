def id(func)
  func
end

def compose(f, g)
  lambda do |args|
    f.call(g.call(args))
  end
end

def double(x)
  2 * x
end

def square(x)
  x * x
end

def add5(x)
  x + 5
end

y = id(method(:double))
puts y.call(5)

dsa = compose(method(:double), compose(method(:square), method(:add5)))
puts dsa.call(0)

x = compose(method(:id), method(:add5))
puts x.call(0) == 5
