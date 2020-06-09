class SecretWord
  attr_reader :word

  def initialize()
    @word = File.readlines("5desk.txt", chomp: true).select { |word| (5..12).cover? word.length }.sample.upcase
  end
end
