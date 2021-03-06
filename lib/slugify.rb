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
        ["'", '’'],
        ['"', 'ˮ'],
        ['%', '％'],
        ['&', '＆'],
        ['(', ''],
        [')', ''],
        ['?', ''],
        ['!', ''],
        ['·', ''],
        ['.', '']
      ]
      slug = name.squish
      replacements.each{ |p| slug.gsub!(p[0],p[1])}
      slug[-1..-1] = '' if slug.last == ','
    end
    slug = '-NA-' if slug.blank?
    return slug.mb_chars.downcase
  end
end