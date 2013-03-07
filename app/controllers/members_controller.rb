class MembersController < ApplicationController
  before_filter :authenticate_member!
  
  def dashboard
  	set_seo_meta(current_member.name)
  end

  def edit
  	set_seo_meta(t("members.edit",:name => current_member.name))
  end

  def show
  	role_ok = Member::ROLE.include?(params[:role])  
    if role_ok and @user = Member.send(params[:role]).find_by_uid(params[:uid])
      set_seo_meta(@user.name)     
    else
      redirect_to "/not_found"
    end
  end

  # 会员入口
  # 付费成功后回调
  def apply_uid
    current_member.update_attribute(:role,"u")
  end

end
