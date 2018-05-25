class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit]
  
  def index
#    @tasks = Task.all.page(params[:page])
    @tasks = current_user.task.all.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @tasks = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Taskが正常に投稿されました'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Taskが投稿されませんでした'
      render 'toppages/index'
    end
  end

  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = 'Taskが正常に投稿されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'Taskが投稿されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:succcess] = 'Taskは正常に削除されました'
    redirect_back(fallback_location: root_path)
  end

private

def set_task
  @task = Task.find(params[:id])
end

def task_params
  params.require(:task).permit(:content, :status)
end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end
