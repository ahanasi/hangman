class Display
  attr_reader :display

  def initialize()
    @display = ""
  end

  def blank_slate(word)
    (word.length).times { @display.concat("__\s") }
    @display
  end
end
