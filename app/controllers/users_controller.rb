class UsersController < ApplicationController
  before_filter :signed_in_user, 		only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   		only: [:edit, :update]
  before_filter :admin_user,     		only: :destroy
  before_filter :signed_in_user_filter, only: [:new, :create]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new  
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end    
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'  
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    user = User.find(params[:id])
    if (current_user == user) && (current_user.admin?)
      flash[:error] = "Can not delete own admin account!"
    else
      user.destroy
      flash[:success] = "User destroyed."
    end    
    redirect_to users_path
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def signed_in_user_filter
      if signed_in?
        flash[:info] = "You're already logged in, so you cannot create a new account."
        redirect_to root_path
      end    
    end
end
