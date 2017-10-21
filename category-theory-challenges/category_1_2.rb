def memoize(f)
  memoized_vals = {}
  lambda do |*args|
    return memoized_vals[args] unless memoized_vals[args].nil?
    memoized_vals[args] = f.call(*args)
    return memoized_vals[args]
  end
end

def sleepy_factorial(n)
  sleep(1)
  return 1 if n <= 1
  n * sleepy_factorial(n - 1)
end

factorial = memoize(method(:sleepy_factorial))
puts factorial.call(4)
puts factorial.call(4)
puts factorial.call(3)
puts factorial.call(3)

first_rand = memoize(method(:rand))
puts first_rand.call(100)
puts first_rand.call(100)
puts first_rand.call(100)
