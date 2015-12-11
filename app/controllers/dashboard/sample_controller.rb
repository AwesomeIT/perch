class Dashboard::SampleController < ApplicationController
  def index
    @samples = Sample.paginate(:page => params[:page], :per_page => 15)
  end

  def create

  end

  def create_sample
    Api::SampleController.create
  end

end