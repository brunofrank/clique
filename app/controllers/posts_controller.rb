class PostsController < ApplicationController
  before_action :set_group
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = @group.posts.order("updated_at DESC")
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    render turbo_stream: turbo_stream.update(
      @post,
      partial: 'form', locals: { post: @post }
    )
  end

  # POST /posts or /posts.json
  def create
    @post = @group.posts.new(post_params.merge(author: current_user, group: @group))

    respond_to do |format|
      if @post.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend(
            "group_#{@group.id}_posts",
            PostItemComponent.new(
              post: @post,
              current_user: current_user
            ).render_in(view_context)
          )
        end
        format.html { redirect_to group_posts_url(@group), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            @post,
            PostItemComponent.new(
              post: @post,
              current_user: current_user
            ).render_in(view_context)
          )
        end
        format.html { redirect_to group_posts_url(@group), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to group_posts_url(@group), notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = @group.posts.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content, :author_id, :group_id)
  end
end
