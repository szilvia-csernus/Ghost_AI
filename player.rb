require_relative "game.rb"

class Player

    attr_reader :name 
    attr_accessor :lives

    def initialize(name, lives_count)
        @name = name
        @lives = lives_count
    end

    def player_input(fragment, pseudo)
        input = gets.chomp.downcase
        trial = fragment + input
        while Game.guess_invalid?(input, trial)
            puts "Your input is invalid. Please write a letter so that the word fragment potentially makes up a word:"
            input = gets.chomp.downcase
            trial = fragment + input
        end
        fragment = trial
    end

end