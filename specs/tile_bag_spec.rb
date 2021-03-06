require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/tile_bag.rb'

describe "TileBag" do
  describe "initalize" do
    let (:tile_bag) {Scrabble::TileBag.new}

    it "can be instantiated" do
      tile_bag.must_be_instance_of Scrabble::TileBag
    end

    it "creates an array of default tiles" do
      tile_bag.must_respond_to :tiles
      tile_bag.tiles.must_be_instance_of Array
    end

    it "makes the elements of the tile array single letter strings" do
      tile_bag.tiles.each do |tile|
        tile.must_be_instance_of String
        tile.length == 1
      end
    end

    it "creates an array with the correct number of tiles" do
      number_of_tiles = tile_bag.tiles.length
      number_of_tiles.must_equal 98
    end
  end

  describe "draw_tiles" do
    it "returns an array" do
      tile_bag = Scrabble::TileBag.new

      tiles_drawn = tile_bag.draw_tiles(3)
      tiles_drawn.must_be_instance_of Array
    end

    it "removes the correct number of tiles from the tiles array" do
      tile_bag = Scrabble::TileBag.new
      initial_num_of_tiles = tile_bag.tiles.length

      tile_bag.draw_tiles(3)
      expected_tiles_left = initial_num_of_tiles - 3
      tiles_left = tile_bag.tiles.length

      tiles_left.must_equal expected_tiles_left
    end

    it "draws the correct number of tiles" do
      tile_bag = Scrabble::TileBag.new
      tiles_drawn = tile_bag.draw_tiles(5)

      tiles_drawn.size.must_equal 5
    end

    it "raises an error if the argument isn't an integer" do
      tile_bag = Scrabble::TileBag.new

      proc {
        tile_bag.draw_tiles("two")
      }.must_raise ArgumentError
    end

    it "requires a positive argument" do
      tile_bag = Scrabble::TileBag.new

      proc {
        tile_bag.draw_tiles(-5)
      }.must_raise ArgumentError
    end

    it "returns the remaining tiles if there are not enough tiles to draw" do
      tile_bag = Scrabble::TileBag.new
      # 98 default tiles
      tile_bag.draw_tiles(94) # 4 remaining tiles
      tiles_drawn = tile_bag.draw_tiles(8)

      tiles_drawn.length.must_equal 4
    end

    it "doesn't modify the tiles array if 0 tiles are drawn" do
      tile_bag = Scrabble::TileBag.new
      default_number_of_tiles = 98

      tiles_drawn = tile_bag.draw_tiles(0)

      tiles_drawn.must_be_empty
      tile_bag.tiles.length.must_equal default_number_of_tiles
    end

    it "allows the tile bag to become empty" do
      tile_bag = Scrabble::TileBag.new
      tile_bag.draw_tiles(98) # 98 default tiles

      tile_bag.tiles.must_be_empty
    end
  end
#
  describe "tiles_remaining" do
    it "returns an integer" do
      tile_bag = Scrabble::TileBag.new
      tile_bag.tiles_remaining.must_be_instance_of Integer
    end

    it "returns # of tiles left in the bag" do
      tile_bag = Scrabble::TileBag.new
      default_number_of_tiles = 98
      tile_bag.draw_tiles(10)
      tile_bag.tiles_remaining.must_equal default_number_of_tiles - 10
    end

    it "returns the default # of tiles if no tiles have been drawn" do
      tile_bag = Scrabble::TileBag.new
      default_number_of_tiles = 98
      tile_bag.tiles_remaining.must_equal default_number_of_tiles
    end

    it "returns 0 if there are no tiles remaining in the tile bag" do
      tile_bag = Scrabble::TileBag.new
      tile_bag.draw_tiles(98) # defauly number of tiles
      tile_bag.tiles_remaining.must_equal 0
    end
  end
end
