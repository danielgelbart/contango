class DownloadsController < ApplicationController

  def download_statement
    # how to pass search id?
    id = params[:search_id]
    begin
      @search = Search.find(id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "OOPs cant get that"
      # redirect_to :action => 'error_page'
    end

    # (can check here if user paid for download)

    file_name = @search.file_name
    @search.update_attribute(:file_downloaded, true)

    #supply file for download
    send_file(File.join(Rails.root,"public/statements/",file_name),
              filename: file_name)

    # do NOT render view after this method
  end


end
