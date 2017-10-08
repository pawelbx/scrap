module Helpers
  def self.factorial(n)
    (1..n).inject(:*) || 1
  end

  def self.combination(n, k)
    factorial(n) / (factorial(k) * factorial(n - k))
  end

  def self.integer_partitions(sum_to, max, groups)
    return nil if groups * max < sum_to
    return [[sum_to]] if groups == 1
    sums = []
    up_to = max > sum_to ? sum_to : max
    (0..up_to).each do |n|
      rest_sums = integer_partitions(sum_to - n, max, groups - 1)
      next if rest_sums.nil?
      rest_sums.each do |rest_sum|
        res = [n].concat(rest_sum.flatten)
        sums.push(res)
      end
    end
    sums
  end
end
