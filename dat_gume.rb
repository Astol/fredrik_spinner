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
      @player.x_vel = 10 + @player.velocity / 2
    elsif Gosu::button_down? Gosu::KbLeft then
      @player.x_vel = -10 - @player.velocity / 2
    else
      @player.x_vel = 0
    end
    if Gosu::button_down? Gosu::KbUp then
      @player.y_vel = -15
      @player.jumping = true
    end
    @player.move
    @player.update
    @enemys.each do |b|
      b.update
    end
    random_broccoli
    freddy_nomnom?
    @stats.rpm = @player.velocity * 10
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
    if rand(1000) <= 5 + @player.velocity / 2
      @enemys.push(Broccoli.new(3 + (@player.velocity / 2) + rand(10)))
    end
  end

  def freddy_nomnom?
    @enemys.each do |b|
      if intersects?(@player.gethitbox, b.gethitbox)
        b.killed = true
        @player.velocity += 1
      end
      if b.y > 1000
        b.killed = true
        if @player.velocity > 0
          @player.velocity -= 2
          if @player.velocity < 0
            @player.velocity = 0
          end
        end
      end
    end
    @enemys.keep_if do |b| !b.killed end
  end
  # easter egg i koden
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
    #@font.draw("TIME: " + @time.to_s, 0, 0, 0)
  end
end


class Fredrik
  attr_accessor :x,:y,:x_vel,:velocity, :jumping, :y_vel
  def initialize
    @cl_animation = [Gosu::Image.new("kitty_L1.png"), Gosu::Image.new("kitty_L2.png"), Gosu::Image.new("kitty_L3.png")]
    @cr_animation = [Gosu::Image.new("kitty_R1.png"), Gosu::Image.new("kitty_R2.png"), Gosu::Image.new("kitty_R3.png")]
    @fredrik_left = [Gosu::Image.new("freddy_L.png"), Gosu::Image.new("freddy_LK.png")]
    @fredrik_right = [Gosu::Image.new("freddy_R.png"), Gosu::Image.new("freddy_RK.png")]
    @fredrik_head = @fredrik_left[0]
    @fredrik_is_kawaii = 0
    @current_img = 1
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

    @jumping = false
    @y_vel = 0
  end

  def gethitbox
    return [@x, @y, 142, 212]
  end



  def update
    @count += 1
    @rotation += @velocity
    @rotation %= 360

    if @count == 15 then
      @count = 0
      @current_img += 1
      if @current_img == 3
        @current_img = 1
      end
    end

    if @velocity > 2 then
      @fredrik_is_kawaii = 1
    else
      @fredrik_is_kawaii = 0
    end
  end

  def move
    if @jumping then
      @y_vel += 1
      @y += @y_vel
      @by += @y_vel
      if @y_vel == 0 then
        @jumping = false
      end
    end

    if !(@x_vel == 0) then
      @x += @x_vel
      if @x > 650 then
        @x = 650
      end
      if @x < 0 then
        @x = 0
      end
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
      @fredrik_head = @fredrik_right[@fredrik_is_kawaii]
      @cat = @cr_animation[@current_img]
      @direction_left = false
      @bx = @x

    elsif @x_vel < 0 then
      @fredrik_head = @fredrik_left[@fredrik_is_kawaii]
      @cat = @cl_animation[@current_img]
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
  end


  def draw
    @broccoli.draw(@x,@y, 0, 0.0861, 0.0861)
  end

end


window = GameWindow.new
window.show
