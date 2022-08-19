class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id].to_i)
    if params[:comment_id].present?
      @comment = Comment.find(params[:comment_id])
      @like = Like.new(likable_id: @comment.id,
                    likable_type: "Comment",
                    user_id: current_user.id,
                    post_id: @post.id)      
      @comment_likes = @comment.likes      
    elsif params[:post_id].present?
      @like = Like.new(likable_id: @post.id, 
              likable_type: "Post", 
              user_id: current_user.id,
              post_id: @post.id)
      @post_likes = @post.likes
    end
   @like.save
    # respond_to do |format|
    #   format.turbo_stream {render 'likes/post_create'}
    # end
  
  end

  def destroy
    @check = ""
    if params[:comment_id].present?
      
      @comment = current_user.likes.find_by(id: params[:comment_id])
      @like = Like.where(likable_id: params[:comment_id].to_i, 
                         user_id: current_user.id)
      @check = "Comment"

      @like.each do |like|
        like.delete if like.likable_type == "Comment"
      end
      @comment_likes = Comment.find(params[:comment_id]).likes
    else
      @post = current_user.posts.find_by(id: params[:post_id])
      @like = Like.where(likable_id: params[:post_id].to_i, user_id: current_user.id)
      @check = "Post"
      @like.each do |like|
        like.delete if like.likable_type == "Post"
      end
      @post_likes = @post.likes
      # respond_to do |format|
      #   format.turbo_stream {render 'likes/post_destroy'}
      # end
    end
  end
end