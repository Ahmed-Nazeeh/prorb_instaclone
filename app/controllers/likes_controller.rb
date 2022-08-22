class LikesController < ApplicationController
  before_action :find_post_comment

  def create
    if params[:comment_id].present?
      @like = Like.new(likable_id: @comment.id, likable_type: "Comment", user_id: current_user.id, post_id: @post.id)      
      @comment_likes = @comment.likes 
      if @like.save
        respond_to do |format| 
          format.turbo_stream { render 'likes/comment_create', locals: { like: @like } } 
        end
      end     
    elsif params[:post_id].present?
      @like = Like.new(likable_id: @post.id, likable_type: "Post", user_id: current_user.id, post_id: @post.id)
      @post_likes = @post.likes
      if @like.save
        respond_to do |format| 
          format.turbo_stream { render 'likes/post_create', locals: { like: @post }} 
        end
      end 
    end
  end

  def destroy
    if params[:comment_id].present?
      @like = Like.where(likable_id: params[:comment_id].to_i, user_id: current_user.id)
      @like.each { |like| like.delete if like.likable_type == "Comment" }
      @comment_likes = Comment.find(params[:comment_id]).likes
      respond_to do |format| 
        format.turbo_stream {render 'likes/comment_destroy', 
          locals: { like: @like } } 
      end
    else
      @like = Like.where(likable_id: params[:post_id].to_i, user_id: current_user.id)
      @like.each { |like| like.delete if like.likable_type == "Post"}
      @post_likes = @post.likes
      respond_to do |format| 
        format.turbo_stream { render 'likes/post_destroy', 
          locals: { post: @post } } 
      end
    end
  end

  private

  def find_post_comment 
    @post = Post.find(params[:post_id].to_i)
    @comment = Comment.find(params[:comment_id].to_i) if params[:comment_id]
  end
end