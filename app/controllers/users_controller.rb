class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  before_action :require_current_user, only: [:show]

  def index
#    @users = User.all.page(params[:page])
#    @user = User.find(params[:id])

  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_current_user
    @user = User.find(params[:id])
    unless @user == current_user
     redirect_to login_url
    end
  end
  
end
