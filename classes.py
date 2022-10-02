from pprint import pp
class RingBuffer:

    def __init__(self, k):
        self.q = [None for i in range(k)]
        self.size = k
        self.r = 0
        self.f = 0

    def enQueue(self, val):
        if self.isFull():
            return False
        self.q[self.r] = val
        self.r = (self.r + 1) % self.size
        return True

    def deQeue(self):
        if self.isEmpty():
            return False
        self.f = (self.f + 1) % self.size
        return True
            return -1
        return self.q[self.r - 1]

    def isEmpty(self):
        return self.r - self.f == 0

    def isFull(self):
        return self.r - self.f == self.size

    def __str__(self):
        print(self.f)
        print(self.r)
        return self.q.__str__()

x = RingBuffer(3)
x.enQueue(1)
x.enQueue(2)
x.enQueue(3)
x.enQueue(4)
x.enQueue(5)
x.enQueue(6)
x.enQueue(7)

x.deQeue()
x.deQeue()
x.deQeue()
x.enQueue(5)
x.enQueue(6)
x.enQueue(7)
x.enQueue(8)
print(x)
#
#  m4
#m3   m2
#   m1
# 
