#require 'reloader/sse'

class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy, :chat, :events]

  include ActionController::Live

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  #GET /rooms/1/events
  def events
    response.headers["Content-Type"] = "text/event-stream"
    redis = Redis.new
    redis.psubscribe('chat.*') do |on|
      on.pmessage do |pattern, event, data|
        #raise [pattern, event, data].join(" - ")
        logger.info "#{pattern} - #{event} - #{data}"
        response.stream.write("event: #{event}\n")
        response.stream.write("data: #{data}\n\n")
      end
    end
    rescue IOError
      logger.info "Stream closed"
    ensure
      redis.quit
      response.stream.close
  end
  #def events
  #  response.headers["Content-Type"] = "text/event-stream"
  #  3.times do |n|
  #    response.stream.write "#{n}... \n"
  #    sleep 2
  #  end
  #  rescue IOError
  #    logger.info "Stream closed"
  #  ensure
  #    response.stream.close
  #end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    @room.user = current_user

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render action: 'show', status: :created, location: @room }
      else
        format.html { render action: 'new' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end
  # POST /rooms/1/chat
  def chat
    #room should be defined
    response.headers["Content-Type"] = "text/javascript"
    @chat = Chat.create(content: params[:content], user_id: current_user_id, room_id: @room.id)
    data = @chat.to_json
    #data[:user] = @chat.user.name
    event_name = 'chat.add_' + @chat.room_id.to_s
    $redis.publish(event_name, data)
  end


  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :topic)
    end
    def chat_params
      #not tested yet
      params.permit(:content)
    end
end
