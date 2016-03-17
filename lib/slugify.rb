# encoding: utf-8

module Slugify
  def slugify name = ''
    if name.blank?
      slug = ''
    else
      replacements = [
        [' ', '-'],
        ['#', '·'],
        ['*', '·'],
        ['/', '⁄'],
        ["'", 'ʼ'],
        ['"', 'ˮ'],
        ['%', '％'],
        ['&', '＆'],
        ['(', ''],
        [')', ''],
        ['?', ''],
        ['!', ''],
        ['.', '']
      ]
      slug = name.squish
      replacements.each{ |p| slug.gsub!(p[0],p[1])}
    end
    return slug.mb_chars.downcase
  end
end