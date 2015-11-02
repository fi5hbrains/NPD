class User < ActiveRecord::Base
  include Slugify
  
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    c.login_field = 'name'
    c.validate_email_field = false
    c.require_password_confirmation = false
  end
  
  attr_accessor :invite_phrase, :crop_coords

  before_validation :name_to_slug
  after_create :cancel_invite, :give_invites, :make_default_boxes
  
  has_many :invites, dependent: :destroy
  has_one  :invite, foreign_key: 'used_by'
  has_many :boxes, -> { order 'name ASC' }, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :votes, class_name: 'UserVote', dependent: :destroy
  has_many :comments

  validate :excluded_name?
  validate :valid_invite?, on: :create
  
 mount_uploader :avatar, AvatarUploader  

  def self.ghost
    new(name: I18n.t('Ghost'), slug: 'ghost')
  end

  def to_param; slug end
  
  def name_to_slug
    unless self.name.squish!.empty?
      self.slug = slugify(self.name)
    end
  end  
  
  private

  def valid_invite?
    if new_record?
      unless Defaults::SYSTEM_NAMES.include?(self.name) || User.count == 0 || Invite.where(used_by: nil, word: invite_phrase.try(:strip)).count > 0 
        errors.add(:invite_phrase, "to register you need to say the secret word")
      end
    end
  end
  def excluded_name?
    if Defaults::RESERVED_NAMES.include?( self.name)
      errors.add(:name, "You don't want to take that name here, #{name}")
    end
  end
  def cancel_invite
    invite = Invite.where(used_by: nil, word: invite_phrase.try(:strip)).first
    if invite
      invite.used_by = id
      invite.save
    end
  end
  def give_invites; 2.times {Invite.give_to self}; end
  def make_default_boxes
    %w(collection giveaway wishlist).each{ |box| self.boxes.new(name: box).save }
  end
end
