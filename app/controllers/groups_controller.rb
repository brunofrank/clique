class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy join leave kick_out]

  # GET /groups or /groups.json
  def index
    if filter_params[:filter] == "created_by_me"
      @groups = Group.created_by(current_user)
    elsif filter_params[:filter] == "member"
      @groups = Group.is_member(current_user)
    else
      @groups = Group.all
    end
  end

  # GET /groups/1 or /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  def join
    @group.members << current_user

    render turbo_stream: turbo_stream.update(
      "group_#{@group.id}",
      GroupItemComponent.new(
        group: @group,
        current_user: current_user
      ).render_in(view_context)
    )
  end

  def leave
    @group.members.delete(current_user)

    render turbo_stream: turbo_stream.update(
      "group_#{@group.id}",
      GroupItemComponent.new(
        group: @group,
        current_user: current_user
      ).render_in(view_context)
    )
  end

  def kick_out
    member = User.find(params[:member_id])
    @group.members.delete(member)

    render turbo_stream: turbo_stream.update(
      "group_#{@group.id}_members",
      partial: "posts/members", locals: { group: @group }
    )
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params.merge(owner: current_user))

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name)
  end

  def filter_params
    params.permit(:filter)
  end
end
