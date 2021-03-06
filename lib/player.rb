require_relative 'scoring'
require_relative 'tile_bag'

module Scrabble
  class Player
    attr_reader :name, :plays, :tiles

    def initialize(name)
      raise ArgumentError.new("name must be a string") if !name.is_a? String
      @name = name
      @plays = []
      @tiles = []
    end

    def play(word)
      return false if won?
      word_score = Scrabble::Scoring.score(word)
      @plays << word
      return word_score
    end

    # returns the sum of scores of played words
    def total_score
      return 0 if @plays.empty?
      word_scores = @plays.map {|word| Scrabble::Scoring.score(word)}
      word_scores.sum
    end

    def won?
      total_score >= 100
    end

    # returns the highest scoring played word
    def highest_scoring_word
      Scrabble::Scoring.highest_score_from(@plays)
    end

    # returns the highest_scoring_word score
    def highest_word_score
      Scrabble::Scoring.score(highest_scoring_word)
    end

    def draw_tiles(tile_bag)
      raise ArgumentError.new("tile_bag must be a TileBag") if !tile_bag.is_a? TileBag

      tiles_to_draw = 7 - @tiles.length # player cannot have more than 7 tiles at a time

      new_tiles = tile_bag.draw_tiles(tiles_to_draw)
      @tiles += new_tiles
    end
  end
end
