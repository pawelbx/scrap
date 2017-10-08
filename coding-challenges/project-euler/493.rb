require 'benchmark'
require_relative 'helpers'

def compute_probability(result, denom, colors)
  num_marbles = 10
  num = result.reduce(1) do |accum, num_color|
    accum *= Helpers.combination(num_marbles, num_color)
    accum
  end
  res = num / denom.to_f
  res
end

def solve
  denom = Helpers.combination(70, 20)
  expected_color_vals = Array.new(8, 0)
  results = Helpers.integer_partitions(20, 10, 7)
  results.each do |result|
    colors = result.reduce(0) do |memo, color|
      memo += color > 0 ? 1 : 0
      memo
    end
    prob = compute_probability(result, denom, colors)
    expected_color_vals[colors] += prob
  end
  puts expected_color_vals.each_with_index.map { |p, i| p * i }.reduce(:+)
end

t = Benchmark.measure { solve() }
puts t
