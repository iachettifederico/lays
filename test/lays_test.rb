require_relative "./test_helper"

Frame = Struct.new(:content) do
  include Lays
  def initialize(attrs={})
    attrs.each do |attr, val|
      self.send("#{attr}=", val)
    end
  end
end

test "one layer, one line" do
  frame = Frame.new
  frame[1] = "hello"
  assert_equal frame.to_s, "hello"
end

test "one layer, multiple lines" do
  frame = Frame.new
  frame[1] = "hello\none\ntwo"
  assert_equal frame.to_s, "hello\none\ntwo"
end

test "two layers, one line, same size" do
  frame = Frame.new
  frame[1] = "one"
  frame[2] = "two"
  assert_equal frame.to_s, "two"
end

test "two layers, one line, same size, switched" do
  frame = Frame.new
  frame[2] = "two"
  frame[1] = "one"
  assert_equal frame.to_s, "two"
end

test "two layers, one line, different size" do
  frame = Frame.new
  frame[2] = "123"
  frame[5] = "abcdef"
  assert_equal frame.to_s, "abcdef"
end

test "two layers, one line, different size" do
  frame = Frame.new
  frame[6] = "123"
  frame[3] = "abcdef"
  assert_equal frame.to_s, "123def"
end

test "two layers, two lines" do
  frame = Frame.new
  frame[2] = "222\n2"
  frame[1] = "11\n111"
  assert_equal frame.to_s, "222\n211"
end

test "three layers, three lines" do
  frame = Frame.new
  frame[3] = <<-THREE
3 3
 3
333
  THREE
  frame[2] = <<-TWO
22
222 2
 222
  TWO
  frame[1] = <<-ONE
1111111
111111
11111
  ONE

  res = <<-RES.chomp
3231111
232121
33321
  RES
  assert_equal frame.to_s, res
end


test "re-rendering frames" do
  frame = Frame.new
  frame[2] = "two"
  frame[1] = "one"
  frame.to_s

  frame[2] = "* *"
  frame.to_s

  frame[8] = "   #"
  res = frame.to_s

  assert_equal res, "*n*#"
end

scope do
  # width and height
  setup do
    frame = Frame.new
    frame[3] = "a"
    frame[2] = "bcde"
    frame[1] = "fg"
    frame
  end

  test "width" do |frame|
    assert_equal frame.width, 4
  end

  test "height" do |frame|
    assert_equal frame.height, 3
  end
end

scope do
  # Transparency
  test "transparent char" do
    frame = Frame.new

    frame[6] = "0=0 0"
    frame[6].transparent_char = "="
    frame[3] = "11111"
    assert_equal frame.to_s, "010 0"
  end

  test "setting transparent char beforehand" do
    frame = Frame.new

    frame[6].transparent_char = "#"
    frame[6] = "2 # 2"
    frame[3] = "11111"
    assert_equal frame.to_s, "2 1 2"
  end

  test "setting global transparent char for frame" do
    frame = Frame.new
    frame.transparent_char = "$"

    frame[6] = "2 $ 2"
    frame[3] = "11111"
    assert_equal frame.to_s, "2 1 2"
  end

  test "full transparency example" do
    frame = Frame.new
    frame.transparent_char = "$"

    frame[9].transparent_char = "*"
    frame[6].transparent_char = "%"

    frame[9] =               "3**$***3 "
    frame[6] =               "22%2$%%2 "
    frame[3] =               "11111$$1 "
    frame[1] =               "000000$0 "
    assert_equal frame.to_s, "321$$0 3 "

  end

end
