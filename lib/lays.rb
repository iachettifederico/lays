require "lays/version"
require "ostruct"

module Lays

  Layer = Struct.new(:content, :transparent_char) do
    def initialize(attrs={})
      attrs.each do |attr, val|
        self.send("#{attr}=", val)
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
      content = layer.content
      content.split("\n").each_with_index.map do |line, i|
        line.each_char.each_with_index do |c, j|
          result[i] ||= []
          if !transparent_char_for(layer, c)
            result[i][j] = c
          elsif key == lays.first.first
            result[i][j] = " "
          end
        end
      end
    end
    result.map {|a|a.join}.join("\n")
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
  end

  def transparent_char
    @transparent_char ||= " "
  end

  def transparent_char_for(layer, char)
    transparent = layer.transparent_char || transparent_char
    char == transparent
  end
end
