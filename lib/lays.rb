require "lays/version"
require "ostruct"

module Lays

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
    layers[id] ||= OpenStruct.new
  end
  
  def layers
    @layer ||= {}
  end

  def to_s
    @result ||= render
  end

  def render
    result = []
    layers.sort {|a, b| a[0] <=> b[0] }.each do |_, layer|
      content = layer.content
      content.split("\n").each_with_index.map do |line, i|
        line.each_char.each_with_index do |c, j|
          result[i] ||= []
          transparent = layer.transparent || " "
          result[i][j] = c unless c == nil || c == transparent
        end
      end
    end
    result.map {|a|a.join}.join("\n")
  end
end
