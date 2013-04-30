class ChatController < WebsocketRails::BaseController

	def initialize_session
      controller_store[:user_count] = 0
  end

	def client_connected
  	controller_store[:user_count] += 1
    #send_message :enter, data
  end

  def delete_user
  	controller_store[:user_count] -= 1
    if connection_store.keys.length == 1
      channel = connection_store.keys[0]
      send_leave(channel)
    end
 	end

 	def new_message
    channel = message["cid"]
    WebsocketRails[channel].trigger 'success', message
 	end

  def enter_channel
      channel = data["cid"]
      mids = connection_store.collect_all(channel).compact
      if mids.length < 5
        guys = Member.where(:_id.in => mids)
        connection_store[channel] = current_member._id
        newer = current_member.as_profile
        data = {
          :guys => guys.collect{|x| x.as_profile},
          :newer => newer
        }

        WebsocketRails[channel].trigger 'enter', data
      else
        WebsocketRails[channel].trigger 'enter_fail'
      end 
  end

  def leave_channel
      channel = data["cid"]
      send_leave(channel)
  end

  private
  def send_leave(channel)
    connection_store[channel] = nil
    leaver = current_member.as_profile
    WebsocketRails[channel].trigger 'leave', leaver
  end
end
