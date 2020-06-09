class Display
  attr_accessor :display
  def initialize()
    @display = ""
  end

  def blank_slate(word)
   (word.length).times { @display.concat("_ ") }
  end
end

