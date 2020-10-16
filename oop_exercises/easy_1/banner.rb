#Behold this incomplete class for constructing boxed banners.

class Banner
  def initialize(message, width = message.size)
    @message = message
    @width = width
    if width < message.size
      @width = message.size
    end
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{'-' * @width}-+"
  end

  def empty_line
    "| #{' ' * @width} |"
  end

  def message_line
    "| #{@message.center(@width)} |"
  end
end


#Complete this class so that the test cases shown below work as intended. You are free to add any methods or instance 
#variables you need. However, do not make the implementation details public.

#You may assume that the input will always fit in your terminal window.

banner = Banner.new('To boldly go where no one has gone before.', 13)
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

banner = Banner.new('')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+
