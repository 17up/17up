class ChatController < WebsocketRails::BaseController

	def initialize_session
      controller_store[:user_count] = 0
  end

	def client_connected
  	controller_store[:user_count] += 1
    data = {
      :avatar => current_member.avatar,
      :name => current_member.name,
      :count => controller_store[:user_count]
    }
    send_message :enter, data
  end

  def delete_user
  	controller_store[:user_count] -= 1
    data = {
      :avatar => current_member.avatar,
      :name => current_member.name,
      :count => controller_store[:user_count]
    }
    send_message :leave, data
 	end

 	def new_message
    channel = message["cid"]
    WebsocketRails[channel].trigger 'success', message
 	end

  def enter_channel
      channel = data["cid"]
      if controller_store[channel]
        controller_store[channel] += 1
      else
        controller_store[channel] = 1
      end

      data = {
        :_id => current_member._id,
        :avatar => current_member.avatar,
        :name => current_member.name
      }
      WebsocketRails[channel].trigger 'enter', data
  end

  def leave_channel
      channel = data["cid"]
      if controller_store[channel]
        controller_store[channel] -= 1
      else
        controller_store[channel] = 0
      end
      p controller_store[channel]
      data = {
        :_id => current_member._id,
        :avatar => current_member.avatar,
        :name => current_member.name
      }
      WebsocketRails[channel].trigger 'leave', data
  end
end
