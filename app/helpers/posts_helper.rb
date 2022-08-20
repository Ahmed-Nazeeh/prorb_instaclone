module PostsHelper
    def find_like(post,user)
        @found_like = false 
        post.likes.each do |post_like|
            if post_like.likable_type == "Post" && 
                post_like.user_id == current_user.id &&  
                post_like.likable_id == post.id 
                    @found_like = true
            end
        end
    end

    def find_comment_like(post, comment, user)
        @found_comment_like = false 
        comment.likes.each do |comment_like|
            if comment_like.likable_type == "Comment" && 
               comment_like.user_id == current_user.id && 
               comment_like.likable_id == comment.id &&
               comment_like.post_id == post.id
                    @found_comment_like = true
            end
        end
    end

end
