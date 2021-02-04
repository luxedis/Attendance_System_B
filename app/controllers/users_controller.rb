class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :update_all_users_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :update_all_users_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :update_all_users_basic_info]
  before_action :set_one_month, only: :show
  
  def index
    # debugger
    @users = User.paginate(page: params[:page]) # ここでページネートしている
    if params[:name].present? # indexの13行目でtext_field :nameとしているからパラメータがnameになる
      @users = @users.search(params[:name]) #10行めのメー児ねーとされたユーザーを更に検索する。
    end
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    # @first_day = Date.current.beginning_of_month
    # @last_day = @first_day.end_of_month
  end
  
  def new
    @user = User.new # ユーザーオブジェクトを生成し、インスタンス変数に代入する。
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功語、ログインします。
      flash[:success] = '新規作成に成功しました'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報を更新しました。"
      redirect_to @user
    else 
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params) # (department: params[:user][:department], basic_time: params[:user][:basic_time], work_time: params[:user][:basic_time])
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def update_all_users_basic_info
    if User.update(update_all_users_basic_info_params)
      # User.update_all(:basic_time => params[:user][:basic_time], :work_time => params[:user][:work_time]) #update_allはストロングパラが使えないので。上記と動きは同じ
      flash[:success] = "全ユーザーの基本情報を更新しました。"
    else
      flash[:danger] = "全ユーザーの更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to edit_basic_info_user_url(@user)
  end
  
  # def search
  #   @users = User.search(params[:search])
  # end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end
  
  def basic_info_params
    binding.pry# debugger
    params.require(:user).permit(:department, :basic_time, :work_time)
  end
  
  def update_all_users_basic_info_params
    params.require(:user).permit(:basic_time, :work_time)
  end
  
  # def search_params
  #   params.fetch(:search, {}).permit(:name) # fetch/
  # end
  
  # beforeフィルター
  
  # # paramsハッシュからユーザーを取得します
  # def set_user
  #   @user = User.find(params[:id])
  # end # set_userアクションをattendancesコントローラでも使う為、applicationコントローラへ引越し
  
#   # ログイン済みのユーザーか確認する。
#   def logged_in_user
#     unless logged_in?
#       store_location
#       flash[:danger] = "ログインしてください。"
#       redirect_to login_url
#     end
#   end
  
#   # アクセスしたユーザーが現在ログインしているユーザーか確認します。
#   def correct_user
#     redirect_to(root_url) unless current_user?(@user)
#   end
  
#   # システム管理権限所有者か判定します。
#   def admin_user
#     redirect_to root_url unless current_user.admin?
#   end
end