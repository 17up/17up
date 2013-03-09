class MembersController < ApplicationController
  before_filter :authenticate_member!,:except => :show
  before_filter :require_member!,:only => :update
  
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

  # response with js.haml
  def upload_avatar
    file = params[:image].tempfile.path 
    type = params[:image].content_type 
    if current_member.validate_upload_avatar(file,type)
      current_member.save_avatar(file)
      @avatar = current_member.avatar + "?#{Time.now.to_i}"
      render_json 0,t('flash.notice.avatar'),@avatar
    else
      render_json -1,t('flash.error.avatar')
    end
      
  end

  # set uid
  def update  
    if params[:uid].blank?
      flash[:error] = t('flash.error.blank')
    else
      if @user = Member.u.find_by_uid(params[:uid])
        flash[:error] = t('flash.error.uid')
      else
        data = {
          :uid => params[:uid],
          :email => params[:uid] + "@" + $config[:domain]
        }
        current_member.update_attributes(data)
        flash[:notice] = t('flash.notice.uid')
      end
    end
    redirect_to setting_path + "#account"
  end

  private
  def require_member!
    unless current_member.is_member?
      render :status => :unauthorized
    end
  end

end
