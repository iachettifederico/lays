require_relative "./test_helper"

Frame = Struct.new(:content) do
  include Lays
  def initialize(**attrs)
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
  frame[1] = "123"
  frame[2] = "abcdef"
  assert_equal frame.to_s, "abcdef"
end

test "two layers, one line, different size" do
  frame = Frame.new
  frame[2] = "123"
  frame[1] = "abcdef"
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
  frame[3] = <<THREE
3 3
 3
333
THREE
  frame[2] = <<TWO
22
222 2
 222
TWO
  frame[1] = <<ONE
1111111
111111
11111
ONE
  
  res = <<RES.chomp
3231111
232121
33321
RES
  assert_equal frame.to_s, res
end
