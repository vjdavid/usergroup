class Post < ActiveRecord::Base
  REMOVE_CODE_EXPR = /^``` ?(.*?)\r?\n(.+?)\r?\n```\r?$/m

  belongs_to :user

  validates :title, :content, :user, :presence => true
  validates :title, :uniqueness => true

  delegate :username,     :to => :user, :prefix => :author
  delegate :gravatar_url, :to => :user, :prefix => true

  scope :latest, order( 'created_at DESC' )

  attr_accessible :title, :content, :tag_list
  acts_as_taggable

  def self.user_filtered user, tag=nil
    posts = user ? user.posts.latest : self.latest
    return posts unless tag.present?

    posts.tagged_with tag
  end

  def excerpt
    content.gsub( REMOVE_CODE_EXPR, '' ).split( /\n/ ).first
  end
end
