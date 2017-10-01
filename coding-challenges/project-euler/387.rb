require 'prime'
require 'byebug'
require 'benchmark'

@harshad_cache = []
@right_trunc_cache = []
def harshad_number?(num)
  #return @harshad_cache[num] unless @harshad_cache[num].nil?
  digit_sum = to_digits(num).reduce(:+)
  res = (num % digit_sum).zero?
  #@harshad_cache[num] = true if res
  res
end

def right_truncatable_harshad_number?(num)
  #return @right_trunc_cache[num] unless @right_trunc_cache[num].nil?
  digits = to_digits(num)
  digit_length = digits.length - 1
  nums = (0..digit_length).map do |length|
    to_num(digits[0..(digit_length - length)])
  end
  res = nums.reduce(true) { |a, e| a && harshad_number?(e) }
  #@right_trunc_cache[num] = res if res
  res
end

def strong_harshad_number?(num)
  digit_sum = to_digits(num).reduce(:+)
  (num % digit_sum).zero? && Prime.prime?(num / digit_sum)
end

def strong_right_trunctable_harshad_number?(num)
  strong_harshad_number?(num) && right_truncatable_harshad_number?(num)
end

def to_digits(n)
  n.to_s.chars.map(&:to_i)
end

def to_num(digits)
  digits.join.to_i
end

time = Benchmark.measure do
  nums = []
  Prime.each(100_000).each do |p|
    digits = to_digits(p)[0...-1]
    next if digits.length <= 0
    if strong_right_trunctable_harshad_number?(to_num(digits))
      nums << p
    end
  end
  puts "answer #{nums.reduce(:+)}"
  puts "nums: #{nums}"
end

puts "Time: #{time}"
puts "cache size: #{@harshad_cache.length}"
