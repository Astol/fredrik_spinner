# -*- coding: utf-8 -*-
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 800, 1010
    srand(1337)
    self.caption = "Fredrik spinner"

    @player = Fredrik.new
    @stats = Stats.new
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
    @player.update
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
    @stats.draw
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
        @player.velocity += 1
      end
    end
    @enemys.keep_if do |b| !b.killed end
  end

  def intersects? (bbox1, bbox2)
    return bbox1[0] < bbox2[0]+bbox2[2] && bbox1[1] < bbox2[1]+bbox2[3] && bbox1[0]+bbox1[2] > bbox2[0] && bbox1[1]+bbox1[3] > bbox2[1]
  end

end

class Stats
  attr_accessor :time, :rpm
  def initialize
    @time = 0
    @rpm = 0
    @font = Gosu::Font.new(64)
  end

  def draw
    @font.draw("RPM: " + @rpm.to_s, 0, 66, 0)
    @font.draw("TIME: " + @time.to_s, 0, 0, 0)
  end
end


class Fredrik
  attr_accessor :x,:y,:x_vel,:velocity
  def initialize
    @cl_animation = [Gosu::Image.new("kitty_L1.png"), Gosu::Image.new("kitty_L2.png"), Gosu::Image.new("kitty_L3.png")]
    @cr_animation = [Gosu::Image.new("kitty_R1.png"), Gosu::Image.new("kitty_R2.png"), Gosu::Image.new("kitty_R3.png")]
    @fredrik_left = Gosu::Image.new("freddy_L.png")
    @fredrik_right = Gosu::Image.new("freddy_R.png")
    @fredrik_head = @fredrik_left
    @current_img = 0
    @cat = @cl_animation[@current_img]
    @x = 380
    @y = 780
    @rotation = 0
    @velocity = 0
    @bx = @x + 80
    @by = @y +160
    @x_vel = 0
    @direction_left = true
    @count = 0
  end

  def gethitbox
    return [@x, @y, 142, 212]
  end

  def update
    @count += 1
    @rotation += @velocity
    @rotation %= 360
    if @count == 30 && @velocity != 0 then
      @count = 0
      #TODO:: ändra animation, fixa med listor
    end

  end

  def move
    if !(@x_vel == 0) then
      @x += @x_vel
      @x %= 800
    else
      if !@direction_left then
        @cat = @cr_animation[0]
      else
        @cat = @cl_animation[0]
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
    @fredrik_head.draw_rot(@x + 79, @y + 124, 2, @rotation)
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
