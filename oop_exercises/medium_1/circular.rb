# Your task is to write a CircularQueue class that implements a circular queue for arbitrary objects. 
# The class should obtain the buffer size with an argument provided to CircularQueue::new, and should provide 
# the following methods:

# enqueue to add an object to the queue
# dequeue to remove (and return) the oldest object in the queue. 

# It should return nil if the queue is empty.
# You may assume that none of the values stored in the queue are nil (however, nil may be used to designate 
# empty spots in the buffer).
require 'pry'

class CircularQueue

  def initialize(size)
    @queue = Array.new(size)
    @oldest_index = 0
    @newest_index = 0
  end

  def enqueue(value)
    if @queue.any? { |el| el != nil } && @newest_index == @oldest_index
      @oldest_index += 1
      @oldest_index = reset_index(@oldest_index)
    end
    @queue[@newest_index] = value
    @newest_index += 1 
    @newest_index = reset_index(@newest_index)
  end

  def dequeue
    if @queue.any? { |el| el != nil }
      value = @queue[@oldest_index]
      @queue[@oldest_index] = nil
      @oldest_index += 1
      @oldest_index = reset_index(@oldest_index) 
      return value
    else
      nil
    end
  end

  def reset_index(index)
     index % @queue.size
  end

end

class CircularQueue

  def initialize(size)
    @queue = Array.new(size)
  end

  def 
    


queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
p queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2


queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)


puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

# The above code should display true 15 times.

