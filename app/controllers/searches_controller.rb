class SearchesController < ApplicationController
  authorize_resource

  def search
    @results = Search.search(params[:search][:query], params[:search][:filter])
    respond_with(@results)
  end
end
