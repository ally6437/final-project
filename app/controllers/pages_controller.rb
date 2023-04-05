class PagesController < ApplicationController
  def show
    @page = Page.find_by(title: params[:title].capitalize)
    if @page.nil?
      flash[:alert] = "Page not found"
      redirect_to root_path
    end
  end
end
