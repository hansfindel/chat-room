class ForumsController < ApplicationController
  before_action :set_forum, only: [:show, :edit, :update, :destroy, :post, :events]

  # GET /forums
  # GET /forums.json
  def index
    @forums = Forum.all
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
  end

  # GET /forums/new
  def new
    @forum = Forum.new
  end

  # GET /forums/1/edit
  def edit
  end

  # get /forums/1/events
  def events
    response.headers["Content-Type"] = "text/event-stream"
    #last = @forum.forum_posts.last
    #start = last ? last.created_at : Time.now
    start = Time.now - 10.seconds
    ForumPost.uncached do 
      ForumPost.where("created_at > ? and forum_id = ?", start, @forum.id).each do |p|
        response.stream.write("event: forum_post\n")
        response.stream.write("data: #{p.to_json}\n\n") 
        logger.info "in"
      end
      logger.info "Streaming"
    end
    rescue IOError
      logger.info "Stream closed"
    ensure
      response.stream.close
  end

  # POST /forums
  # POST /forums.json
  def create
    @forum = Forum.new(forum_params)

    respond_to do |format|
      if @forum.save
        format.html { redirect_to @forum, notice: 'Forum was successfully created.' }
        format.json { render action: 'show', status: :created, location: @forum }
      else
        format.html { render action: 'new' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end
  # post /forums/1/post
  def post
    response.headers["Content-Type"] = "text/javascript"
    @post = ForumPost.create(content: params[:content], user_id: current_user_id, forum_id: @forum.id)
    data = @chat.to_json
    #data[:user] = @chat.user.name
    #event_name = 'chat.add_' + @chat.room_id.to_s
  end

  # PATCH/PUT /forums/1
  # PATCH/PUT /forums/1.json
  def update
    respond_to do |format|
      if @forum.update(forum_params)
        format.html { redirect_to @forum, notice: 'Forum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.json
  def destroy
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to forums_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum
      @forum = Forum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forum_params
      params.require(:forum).permit(:name)
    end
end
