class MembersController < ApplicationController
  before_filter :authenticate_member!,:except => :show
  
  # page
  def index
  	set_seo_meta(nil)
  end

  # api get
  def dashboard  
    data = {
      :quote => Eva::Quote.new(current_member).single,
      :courses => Eva::Course.new(current_member).list,
      :song => Song.first.as_json
    }

    unless current_member.is_member?
      guides = YAML.load_file(Rails.root.join("doc","guide.yml")).fetch("guide")
      data.merge!(:guides => guides)
    end
    render_json 0,'ok',data
  end

  # api get
  def account
    @providers = Authorization::PROVIDERS.map do |p|
      {
        :provider => p,
        :has_bind => current_member.has_provider?(p) ? true : false,
        :omniauth_url => member_omniauth_authorize_path(p)
      }
    end
    data = current_member.as_json.merge(:providers => @providers)
    render_json 0,'ok',data
  end

  # get provider info
  def provider
    p = current_member.has_provider?(params[:provider])
    data = p.as_json
    if p.provider == "weibo"
      data.merge!(:friends => Wali::Friend.new(p).bilateral)
    end
    render_json 0,"ok",data
  end

  # get current member profile
  def profile
    render_json 0,"ok",current_member.as_profile
  end

  def invite_list
    if p = current_member.has_provider?("weibo")
      @friends = Wali::Friend.new(p).bilateral
    end
    render_json 0,"ok",@friends
  end

  # api get
  def friend
    render_json 0,'ok'
  end

  # api get
  def genius
    render_json 0,'ok'
  end

  # page
  def show
  	role_ok = Member::ROLE.include?(params[:role])  
    if role_ok and @user = Member.send(params[:role]).where(:uid => params[:uid]).first
      set_seo_meta(@user.name)     
    else
      redirect_to "/not_found"
    end
  end

  # 充值
  # post
  def add_gem
    
  end

  # post
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
  # post
  def update  
    if params[:uid].blank?
      render_json -1,t('flash.error.blank')
    else
      if @user = Member.u.where(:uid => params[:uid]).first
        render_json -1,t('flash.error.uid')
      else
        data = {
          :uid => params[:uid],
          :role => "u",
          :gem => 10,
          :email => params[:uid] + "@" + $config[:domain]
        }
        if current_member.update_attributes(data)
          render_json 0,"ok"
        else
          render_json -1,t('flash.error.uid_format')
        end
      end
    end
  end

end
