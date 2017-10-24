require 'will_paginate/array'
class MyfiltersController < ApplicationController
  def index
  	@myfilter = Myfilter.where("user_id = ?", current_user.id)
  	@filters = []
	  @myfilter.each do |f| 
	   @filters << Filter.find(f.filter_id)
     @filters = @filters.paginate(page: params[:page], per_page: 8)
    end
  end

  def delete
  	myfilter = Myfilter.where("user_id = ?", current_user.id).where("filter_id=?", params[:id])
    myfilter.destroy(myfilter)
    redirect_to myfilters_index_path, notice:  "The Filter has been deleted."
  end

  def add
    @myfilter = Myfilter.where("user_id = ?", current_user.id)
    @ownfilters = []
    @myfilter.each do |f| 
      @ownfilters << Filter.find(f.filter_id)
       end
      @filters = Filter.all - @ownfilters
      @filters = @filters.paginate(page: params[:page], per_page: 8)
  end

  def update
    checkboxFilters = []
    for key in params.keys
        if key[0,6] == "filter"
          checkboxFilters.push(key[6, key.length+1])
        end
    end

    for checkboxFilter in checkboxFilters
        Myfilter.create(:user_id =>  current_user.id, :filter_id => checkboxFilter)
    end
    redirect_to myfilters_index_path, notice: "The Filters have been added."
  end
end
