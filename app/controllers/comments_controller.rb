class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = @post.comments.where(reply_to_id: nil).order("created_at DESC") # Only want main comments, the replies will be loaded in the view
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @replying_to = @post.comments.find(params[:reply_to_id])
    # Getting the main comment to avoid deep nested replies
    @replying_to = @replying_to.reply_to if @replying_to.reply_to.present?

    @comment = @post.comments.new(reply_to_id: @replying_to.id)

    render turbo_stream: turbo_stream.append(
      "comment_#{@replying_to.id}",
      partial: 'form', locals: { comment: @comment }
    )
  end

  # GET /comments/1/edit
  def edit
    render turbo_stream: turbo_stream.update(
      @comment,
      partial: 'form', locals: { comment: @comment }
    )
  end

  # POST /comments or /comments.json
  def create
    @comment = @post.comments.new(comment_params.merge(created_by: current_user))

    respond_to do |format|
      if @comment.save
        format.turbo_stream do
          frame_id = @comment.reply_to.present? ? "comment_#{@comment.reply_to.id}_replies" : "post_#{@post.id}_comments"
          render turbo_stream: turbo_stream.prepend(
            frame_id,
            CommentItemComponent.new(
              comment: @comment,
              current_user: current_user
            ).render_in(view_context)
          )
        end
        format.html { redirect_to [@post.group, @post], notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            @comment,
            CommentItemComponent.new(
              comment: @comment,
              current_user: current_user
            ).render_in(view_context)
          )
        end
        format.html { redirect_to [@post.group, @post], notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to [@post.group, @post], notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:content, :reply_to_id)
  end
end
