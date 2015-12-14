class Dashboard::SampleController < ApplicationController
  def index
    @samples = Sample.paginate(:page => params[:page], :per_page => 15)
  end

  def create

  end

  def process_create
    p sample_params
    Sample.create(sample_params)
    redirect_to '/dashboard/samples/index'
  end

  private

  def sample_params
    params.require(:sample).permit(:s3_file, :name, :tags)
  end

end