class Ad < ActiveRecord::Base
  include ColourMethods
  
  mount_uploader :image, AdImageUploader
  mount_uploader :image_hover, AdImageUploader
  def h_range;end
  def h_range=(ranges)
    ranges = ranges.split(';').first(3)
    ranges.each_with_index do |r,i|
      r = r.split('..').map(&:to_i)
      self.send("h#{i}=", r[0]..r[1])
    end
  end
  def s_range;end
  def s_range=(ranges)
    ranges = ranges.split(';').first(2)
    ranges.each_with_index do |r,i|
      r = r.split('..').map(&:to_i)
      self.send("s#{i}=", r[0]..r[1])
    end
  end
  def l_range;end
  def l_range=(ranges)
    ranges = ranges.split(';').first(2)
    ranges.each_with_index do |r,i|
      r = r.split('..').map(&:to_i)
      self.send("l#{i}=", r[0]..r[1])
    end
  end
  def o_range;end
  def o_range=(ranges)
    ranges = ranges.split(';').first(2)
    ranges.each_with_index do |r,i|
      r = r.split('..').map(&:to_i)
      self.send("o#{i}=", r[0]..r[1])
    end
  end
  def self.coloured c = nil
    if c
      where(
      "(h0 @> ? OR h1 @> ? OR h2 @> ?) \
      AND (s0 @> ? OR s1 @> ?) \
      AND (l0 @> ? OR l1 @> ?) \
      AND (o0 @> ? OR o1 @> ?)",
      c[0],c[0],c[0],c[1],c[1],c[2],c[2],c[3],c[3])
    else
      where(nil)
    end
  end
end
