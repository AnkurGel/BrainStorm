class CollegesController < ApplicationController
  def create
    @college = College.new(params[:college])
    if @college.save
      flash[:success] = "College created"
      redirect_to admin_path
    else
      @level = Level.new
      render 'default_pages/admin'
    end
  end

end
