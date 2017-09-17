require 'prime'
require 'byebug'
require 'benchmark'

def factors_of(number)
  primes, powers = number.prime_division.transpose
  exponents = powers.map { |i| (0..i).to_a }
  divisors = exponents.shift.product(*exponents).map do |powers|
    primes.zip(powers).map { |prime, power| prime**power }.inject(:*)
  end
  divisors.sort.map { |div| [div, number / div] }
end

time = Benchmark.measure do
  primes = []
  Prime.each(100_000_001).each { |p| primes[p] = p }
  sum = (2...100_000_000).step(2).reduce(0) do |memo, n|
    next(memo) if primes[n + 1].nil? || primes[(n / 2) + 2].nil?
    divisors = factors_of(n)
    divisors = divisors[0..(divisors.length / 2) - 1].map(&:first)
    divisors.reject! { |e| e == 1 || e == 2 }
    all_prime = true
    divisors.each do |d|
      gen = d + (n / d)
      if primes[gen].nil?
        all_prime = false
        break
      end
    end
    memo += n if all_prime
    memo
  end
  puts sum + 1
end
puts time

# (n / d + d) = g
# 30 / 30 + 30 = 31
# 30 / 15 + 15 = 17
# 30 / 10 + 10 = 13
# 30 / 6 + 6 = 11
# 30 / 5 + 5 = 11
# 30 / 3 + 3 = 13
# 30 / 2 + 2 = 17
# 30 / 1 + 1 = 31 all odd numbers are out
#                 50_000_000

# 10 / 10 + 10 = 11
# 10 / 5 + 5 = 7
# 10 / 2 + 2 = 5
# 10 / 1 + 1 = 11

# 6 / 6 + 6 = 7

#heuristics:
# only need to check prime factors
# only need to check even numbers
