class UrlsController < ApplicationController
  def new
  	#new will render form for new Url and it is the root page.
  	@url = Url.new
  end

  def create
  	#It will generate a random text and initialize the visit count
  	require 'securerandom'
    @url = Url.new(url_params)
    @url.shortened_url = SecureRandom.urlsafe_base64(6)
    @url.visit_count = 0
		if @url.save
			flash[:success] = 'URL added and shortened URL is shortenedurlgen.herokuapp.com/'+ @url.shortened_url
			redirect_to root_path
		else
			flash[:danger] = 'Not added'
			render 'new'
		end
  end

  def index
  	#Page for top 100 visited page
  	@urls = Url.all.order(visit_count: :desc).limit(100)
  	
  end


  def show
  	#get the original url from shortened_url and redirect and increase the visit count
    if params[:shortened_url]
      @url = Url.find_by(shortened_url: params[:shortened_url])
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
