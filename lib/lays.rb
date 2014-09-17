require "lays/version"

module Lays

  def []=(layer, content)
    layers[layer] = content
    @result = nil
  end

  def [](layer)
    layers[layer]
  end
  
  def layers
    @layer ||= {}
  end

  def to_s
    @result ||= []
    layers.sort {|a, b| a[0] <=> b[0] }.each do |_, content|
      content.split("\n").each_with_index.map do |line, i|
        line.each_char.each_with_index do |c, j|
          @result[i] ||= []
          @result[i][j] = c unless c == nil || c == " "
        end
      end
    end
    @result.map {|a|a.join}.join("\n")
  end
end
