class UrlsController < ApplicationController
  def new
  	@url = Url.new
  end

  def create
  	require 'securerandom'
    @url = Url.new(url_params)
    @url.shortened_url = SecureRandom.urlsafe_base64(6)
    @url.visit_count = 0
		if @url.save
			flash[:success] = 'URL added'
			redirect_to root_path
		else
			flash[:danger] = 'Not added'
			render 'new'
		end
  end

  def index
  	
  end

  def show
  	
  end

  protected

		def url_params
			params.require(:url).permit(:address_type, :name, :address_1, :address_2, :city,
																			:state, :pincode, :landmark)
		end
end