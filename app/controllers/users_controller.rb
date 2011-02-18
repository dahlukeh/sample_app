class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :check_signed, :only => [:new, :create]

  def new
    @user = User.new
    @title = "Sign up"
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(:page => params[:page])
      @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App #{@user.name}!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    if (@user.update_attributes(params[:user]))
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    toDelete = User.find(params[:id])
    if toDelete == current_user
      flash[:notice] = "You can not delete yourself."
    else
      flash[:success] = "User deleted"
      toDelete.destroy
    end
    redirect_to users_path
  end

  private



    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:notice] = "You are not that person, and so can't edit them."
        redirect_to(root_path)
      end
    end

    def admin_user
      if current_user.nil?
        flash[:notice] = "You need to sign in first."
        redirect_to(signin_path)
      elsif !current_user.admin?
        flash[:notice] = "You are not an admin."
        redirect_to(root_path)
      end
    end

    def check_signed
      if !current_user.nil?
        flash[:notice] = "You don't need to create another profile!"
        redirect_to current_user
      end
    end

end

