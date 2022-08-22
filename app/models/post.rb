class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likable

  after_create_commit do 
    broadcast_append_to("postsx",
    partial: "posts/post", 
    locals: { post: self }, 
    target: "posts"
    )
  end
end
