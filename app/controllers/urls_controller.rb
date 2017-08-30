class UrlsController < ApplicationController
  def new
  	#new will render form for new Url and it is the root page.
  	@url = Url.new
    #Page for top 100 visited page
    @urls = Url.order(visit_count: :desc).limit(100).paginate(:page => params[:page], :per_page => 10)
  end

  def create
  	#It will generate a random text and initialize the visit count
  	require 'securerandom'
    @urls = Url.order(visit_count: :desc).limit(100).paginate(:page => params[:page], :per_page => 10)
    @url = Url.new(url_params)
    @url.shortened_url = SecureRandom.urlsafe_base64(6)
    @url.original_url = @url.original_url.strip
    @url.visit_count = 0
		if @url.save
			flash[:success] = 'URL added and shortened URL is shortenedurlgen.herokuapp.com/'+ @url.shortened_url
      # If you want to run locally replace shortenedurlgen.herokuapp.com with localhost:3000
			redirect_to root_path
		else
			render 'new'
		end
  end

  def index
  	#Page for top 100 visited page
  	@urls = Url.order(visit_count: :desc).limit(100).paginate(:page => params[:page], :per_page => 10)
  	
  end


  def show
  	#get the original url from shortened_url and redirect and increase the visit count
    if params[:shortened_url]
      @url = Url.find_by(shortened_url: params[:shortened_url])
      safeurl = URI.encode(@url.original_url)
      if @url.start_with?("http://", "https://")
        redirect_to safeurl
        @url.visit_count += 1
        @url.save
      else redirect_to "http://"+safeurl
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
