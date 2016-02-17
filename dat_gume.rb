# -*- coding: utf-8 -*-
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 800, 1000
    srand(1337)
    self.caption = "Fredrik spinner"

    @player = Fredrik.new
    @enemys = []
  end

  def update
    if Gosu::button_down? Gosu::KbRight then
      @player.x_vel = 10
    elsif Gosu::button_down? Gosu::KbLeft then
      @player.x_vel = -10
    else
      @player.x_vel = 0
    end
    @player.move
    @enemys.each do |b|
      b.update
    end
    random_broccoli
    freddy_nomnom?
  end

  def draw
    @player.draw
    @enemys.each do |b|
      b.draw
    end
#kitty-X 80px under. Y- 160 över
  #  @kitty.draw(380,900,0)
  #  @freedy_img.draw(300,740,0)
  end

  def random_broccoli
    if rand(1000) <= 11
      @enemys.push(Broccoli.new(3))
    end
  end

  def freddy_nomnom?
    @enemys.each do |b|
      if intersects?(@player.gethitbox, b.gethitbox)
        b.killed = true
      end
    end
    @enemys.keep_if do |b| !b.killed end
  end

  def intersects? (bbox1, bbox2)
    return bbox1[0] < bbox2[0]+bbox2[2] && bbox1[1] < bbox2[1]+bbox2[3] && bbox1[0]+bbox1[2] > bbox2[0] && bbox1[1]+bbox1[3] > bbox2[1]
  end

end

class Fredrik
  attr_accessor :x,:y,:x_vel
  def initialize
    @c_animation = ["kitty_L1.png", "kitty_L2.png", "kitty_L3"]
    @fredrik_head = Gosu::Image.new("freddy_L.png")
    @cat = Gosu::Image.new("kitty_L1.png")
    @x = 380
    @y = 780
    @bx = @x + 80
    @by = @y +160
    @x_vel = 0
    @direction_left = true
  end

  def gethitbox
    return [@x, @y, 142, 212]
  end

  def move
    if !(@x_vel == 0) then
      @x += @x_vel
      @x %= 800
    else
      if !@direction_left then
        @cat = Gosu::Image.new("kitty_R1.png")
      else
        @cat = Gosu::Image.new("kitty_L1.png")
      end
    end

    self.update_model
  end

  def update_model
    if @x_vel > 0 then
      @fredrik_head = Gosu::Image.new("freddy_R.png")
      @cat = Gosu::Image.new("kitty_R1.png")
      @direction_left = false
      @bx = @x

    elsif @x_vel < 0 then
      @fredrik_head = Gosu::Image.new("freddy_L.png")
      @cat = Gosu::Image.new("kitty_L1.png")
      @direction_left = true
      @bx = @x + 80
    end
  end

  def draw
    @fredrik_head.draw(@x, @y, 2)
    @cat.draw(@bx, @by, 1)
  end
end

class Broccoli
  attr_accessor :x,:y,:y_vel,:killed
  def initialize(v)
    @x = rand(800)
    @y = 50
    @y_vel = v
    @killed = false
    @broccoli = Gosu::Image.new("broccoli.png")
  end

  def gethitbox
    return [@x, @y, 32, 32]
  end

  def update
    @y += y_vel
    if @y > 1000
      @killed = true
    end
  end


  def draw
    @broccoli.draw(@x,@y, 0, 0.0861, 0.0861)
  end

end


window = GameWindow.new
window.show
