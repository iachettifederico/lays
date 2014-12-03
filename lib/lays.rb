$:.unshift(File.expand_path("../", __FILE__))

require "ostruct"

module Lays

  Layer = Struct.new(:content, :transparent_char, :space_char) do
    def initialize(attrs={})
      attrs.each do |attr, val|
        self.send("self.#{attr}=", val)
      end
    end
  end

  def []=(layer, content)
    set_layer(layer)
    layers[layer].content = content
    @result = nil
  end

  def [](layer)
    set_layer(layer)
    layers[layer]
  end

  def set_layer(id)
    layers[id] ||= Layer.new
  end

  def layers
    @layers ||= {}
  end

  def to_s
    @result ||= render
  end

  def render
    result = []
    lays = layers.sort {|a, b| a[0] <=> b[0] }
    lays.each do |key, layer|
      each_char_for(layer) do |layer, char, line_num, col_num|
        result[line_num] ||= []
        if space_char_for(layer, char)
          result[line_num][col_num] = " "
        elsif !transparent_char_for(layer, char)
          result[line_num][col_num] = char
        elsif key == lays.first.first
          result[line_num][col_num] = " "
        end
      end
    end
    result.map {|line|
      line.join
    }.join("\n")
  end

  def height
    layers.count
  end

  def width
    layers.max { |a, b|
      a.last.content.size <=> b.last.content.size
    }.last.content.size
  end

  def transparent_char=(char)
    @transparent_char = char
    @space_char = nil
  end

  def transparent_char
    @transparent_char ||= " "
  end

  def space_char=(char)
    @space_char = char
    @transparent_char = nil
  end

  def space_char
    @space_char
  end

  private

  def each_char_for(layer, &block)
    content = layer.content
    content.split("\n").each_with_index.map do |line, line_num|
      line.each_char.each_with_index do |char, col_num|
        block.call(layer, char, line_num, col_num)
      end
    end

  end

  def transparent_char_for(layer, char)
    transparent = layer.transparent_char || transparent_char
    char == transparent
  end

  def space_char_for(layer, char)
    char == layer.space_char || char == space_char
  end
end
