class LikesController < ApplicationController
  before_action :find_post

  def create
    if params[:comment_id].present?
      @comment = Comment.find(params[:comment_id])
      @like = Like.new(likable_id: @comment.id, likable_type: "Comment", user_id: current_user.id, post_id: @post.id)      
      @comment_likes = @comment.likes 
      if @like.save
        respond_to do |format| 
          format.turbo_stream { render 'likes/comment_create' } 
        end
      end     
    elsif params[:post_id].present?
      @like = Like.new(likable_id: @post.id, likable_type: "Post", user_id: current_user.id, post_id: @post.id)
      @post_likes = @post.likes
      if @like.save
        respond_to do |format| 
          format.turbo_stream { render 'likes/post_create'} 
        end
      end 
    end
  end

  def destroy
    if params[:comment_id].present?
      @comment = current_user.likes.find_by(id: params[:comment_id])
      @like = Like.where(likable_id: params[:comment_id].to_i, user_id: current_user.id)
      @like.each { |like| like.delete if like.likable_type == "Comment" }
      @comment_likes = Comment.find(params[:comment_id]).likes
      respond_to { |format| format.turbo_stream {render 'likes/comment_destroy'} }
    else
      @like = Like.where(likable_id: params[:post_id].to_i, user_id: current_user.id)
      @like.each { |like| like.delete if like.likable_type == "Post"}
      @post_likes = @post.likes
      respond_to do |format| 
        format.turbo_stream { render 'likes/post_destroy' } 
      end
    end
  end

  def find_post 
    @post = Post.find(params[:post_id].to_i)
  end

end