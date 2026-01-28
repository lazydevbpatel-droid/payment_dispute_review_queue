class Admin::UsersController < ApplicationController
	before_action :find_user, only: [:edit, :update, :destroy]

	def new
		@user = User.new
		authorize @user
	end

	def create
		@user = User.new(user_params)
		authorize @user
		binding.pry
		random_password = SecureRandom.base64(12)
		@user.password = random_password
		@user.password_confirmation = random_password
		binding.pry
		if @user.save
			redirect_to root_path, notice: "User created successfully."
		else
			render :new, status: :unprocessable_entity
		end
	end

	def edit
		authorize @user
	end

	def update
		authorize @user

		if @user == current_user
			params[:user].delete(:role)
		end

		if @user.update(user_params)
			redirect_to root_path, notice: "User updated successfully"
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		@user = User.find(params[:id])
		authorize @user 

		if @user == current_user
			redirect_to root_path, alert: "You cannot delete your own account from here."
			return
		end

		@user.destroy
		redirect_to root_path, notice: "User deleted successfully."
	end

  	private

	def find_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:email, :role, :time_zone)
	end
end
