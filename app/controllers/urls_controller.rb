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
  	@urls = Url.all
  	
  end


  def show
    if params[:shortened_url]
      @url = Url.find_by(shortened_url: params[:shortened_url])
      p @url.original_url
      safeurl = URI.encode(@url.original_url)

      if redirect_to "http://"+safeurl
        @url.visit_count += 1
        @url.save
      end
    else
      @url = Url.find(params[:id])
    end
  end

  protected

		def url_params
			params.require(:url).permit(:original_url)
		end
end
