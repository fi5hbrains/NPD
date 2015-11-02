class Invite < ActiveRecord::Base
  scope :unused, -> { where(used_by: nil) }
  
  def self.give_to user
    (invite = user.invites.new(word: generate_word)).save
    return invite.word
  end
  
  private
  def self.generate_word
    amount = rand(128)
    colours = Defaults::PASS_COLOUR
    deserts =  Defaults::PASS_DESSERT
    word = amount.to_s + ' ' + colours[rand(colours.length)] + ' ' +  deserts[rand(deserts.length)].pluralize(amount)
    word = generate_word if self.where(used_by: nil, word: word).count > 0
    return word
  end  
end