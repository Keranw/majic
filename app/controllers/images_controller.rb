require 'rubygems'
 require'rmagick'
 require 'Log.rb'
 require 'will_paginate/array'
class ImagesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :destroy, :trahs, :share]

  def index
  	@images = Image.where("user_id = ?", current_user.id).where("istrash=?", "f")
    @images = @images.paginate(page: params[:page], per_page: 6)
  end

  def shareIndex
    
    @shareinfo = Shareinfo.where("useremail = ?", current_user.email)
    @images = []
    @shareinfo.each do |f| 
    begin
    my_record = Image.find(f.imageid)
    rescue ActiveRecord::RecordNotFound => e
    my_record = nil
    end
    if my_record
    @images <<my_record
  end
    end
  end

  def new
  	@image = Image.new
  end

  def create
    @image = Image.new(image_params)
    @image.user = current_user
    @image.isTrash = false
    if @image.save
      redirect_to images_path, notice: "The iamge #{@image.name} has been uploaded."
    else
      render "new"
    end
  end

  def destory
  	@image = Image.find(params[:id])
    @image.destroy
    redirect_to images_path, notice:  "The image #{@iamge.name} has been deleted."
  end

  def edit
    @image = Image.find(params[:id])
    @myfilter = Myfilter.where("user_id = ?", current_user.id)
    @filters = []
    @myfilter.each do |f| 
    @filters << Filter.find(f.filter_id)
    end
    @lastVersion = Image.find_by("id = ?", @image.lastVersion)
    @nextVersions = Image.where("lastVersion = ?", @image.id)
    @nextVersions = @nextVersions.paginate(page: params[:page], per_page: 3)
    @filters = @filters.paginate(page: params[:page], per_page: 10)
  end

  def changeFormat
     @myfilter = Myfilter.where("user_id = ?", current_user.id)
     @filters = []
     @myfilter.each do |f| 
     @filters << Filter.find(f.filter_id)
     end
     @image = Image.find(params[:image_id])
     filter = Filter.find(params[:filter_id])
     img =  Magick::Image.read("public" + @image.url.to_s).first
     method = filter.value[0,filter.value.length-1]
     thumb = img.send(method)
     
     # If you want to save this image use following
     thumb.write("public/images/#{current_user.id}#{@image.id}.jpg")
     @newImage = "#{current_user.id}#{@image.id}"
     @appliedFilters = filter.name
     @lastVersion = Image.find_by("id = ?", @image.lastVersion)
     @nextVersions = Image.where("lastVersion = ?", @image.id)
     # otherwise send it to the browser as follows
     # send_data(thumb.to_blob, :disposition => 'inline', 
     #                        :type => 'image/jpg')  
      @nextVersions = @nextVersions.paginate(page: params[:page], per_page: 3)
      @filters = @filters.paginate(page: params[:page], per_page: 10)
  end

  def reEdit
     @myfilter = Myfilter.where("user_id = ?", current_user.id)
     @filters = []
     @myfilter.each do |f| 
     @filters << Filter.find(f.filter_id)
     end
     @image = Image.find(params[:image_id])
     filter = Filter.find(params[:filter_id])
     img =  Magick::Image.read("public/images/#{current_user.id}#{@image.id}.jpg").first
     method = filter.value[0,filter.value.length-1]
     thumb = img.send(method)
     
     # If you want to save this image use following
     thumb.write("public/images/#{current_user.id}#{@image.id}.jpg")
     @renewImage = "#{current_user.id}#{@image.id}"
     @appliedFilters = params[:appliedFilters]+","+filter.name
     @lastVersion = Image.find_by("id = ?", @image.lastVersion)
     @nextVersions = Image.where("lastVersion = ?", @image.id)
     # otherwise send it to the browser as follows
     # send_data(thumb.to_blob, :disposition => 'inline', 
     #                        :type => 'image/jpg')   
     @nextVersions = @nextVersions.paginate(page: params[:page], per_page: 3)
     @filters = @filters.paginate(page: params[:page], per_page: 10)
  end

  def save
    @image = Image.new
    @image.lastVersion = params[:image_id]
    @image.appliedFilters = params[:appliedFilters]
  end

  def saveToDB
     @image = Image.new
    @image.user = current_user
    @image.isTrash = false
    @image.lastVersion = params[:lastVersion]
    @image.appliedFilters = params[:appliedFilters]
    @image.name = params[:name]
    @image.tag = params[:tag]
    img =  Magick::Image.read("public/images/#{current_user.id}#{@image.lastVersion}.jpg").first
    lastImage = Image.find_by("id = ?", @image.lastVersion)
    lastUrl = lastImage.url.to_s

    for i in 1...lastUrl.length
      if lastUrl[-i] == "/"
          @url = lastUrl[0,(lastUrl.length-i+1)]
          break
        end
    end

    img.write("public#{@url}#{@image.name}.jpg")    
    image_url = "public#{@url}#{@image.name}.jpg"
    @image.url = File.open(File.join(Rails.root , image_url))
    if @image.save
      redirect_to edit_image_path(@image.id), notice: "The iamge #{@image.name} has been uploaded."
    else
      render "new"
    end
  end

  def download
    @image= Image.find(params[:id])
    send_file "public" + @image.url.to_s
  end

  def trashbin
    @images = Image.where("user_id = ?", current_user.id).where("isTrash = ?", "t")
  end

  def trash
    @image = Image.find(params[:id])
    @image.isTrash = true
    @image.save
    redirect_to images_path
  end

  def share
    @shareinfo = Shareinfo.new()
    @shareinfo.imageid = params[:id]
    @shareinfo.useremail = params[:email]

    begin
    my_record = User.find_by("email=?", @shareinfo.useremail)
    rescue ActiveRecord::RecordNotFound => e
    my_record = nil
    end
    if my_record
    @shareinfo.save
      redirect_to images_path, notice:  "The image has been shared to #{@shareinfo.useremail}."
    else
      redirect_to images_path, notice:  "Please enter the right email of the person you want to share with."
    end

    
  end

  def destroy
    Image.find(params[:id]).destroy
    redirect_to images_trashbin_path, notice:  "The image has been deleted."
  end

  def restore
    @image = Image.find(params[:id])
    @image.isTrash = false
    @image.save
    redirect_to images_trashbin_path, notice: "The image #{@image.name} has been sent back."
  end

  def cleartrash
    @images = Image.where("user_id = ?", current_user.id).where("isTrash = ?", "t")
    @images.each do |f|
      f.destroy
    end
    redirect_to images_trashbin_path, notice:  "Your trash bin has been cleared"
  end

  def view
     @image = Image.find_by("id = ?",params[:image_id])
  end

  


  private
  def image_params
    params.require(:image).permit(:name, :tag, :url, :ownerId, :isTrash, :appliedFilters, :lastVersion)
  end

end
