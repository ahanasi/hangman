require_relative "player.rb"
require_relative "display.rb"
require_relative "secret_word.rb"

class Hangman
  attr_accessor :player_guess, :word, :display

  def initialize()
    @player_guess = Player.new().guess
    @word = SecretWord.new().word
    @display = Display.new().blank_slate(@word)
    @guesses_left = 6
  end

  def ask_player_for_guess()
    #Ask player for guess
    puts "Guess a letter in the secret word!"
    @player_guess = gets.chomp.upcase
  end



end

test = Hangman.new()
puts test.word
puts test.display
test.ask_player_for_guess
puts "Your guess: #{test.player_guess}"
