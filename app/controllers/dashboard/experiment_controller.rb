class Dashboard::ExperimentController < ApplicationController
  def index
    @experiments = Experiment.paginate(:page => params[:page], :per_page => 15)
  end

  def create

  end

  def process_create
    Experiment.create(experiment_params)
    redirect_to '/dashboard/experiments/index'
  end

  def details
    begin
      @experiment = Experiment.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Experiment URL is not valid / experiment not found.'
      redirect_to '/dashboard/experiments/index'
    end
  end

  def edit
    begin
      @experiment = Experiment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Experiment URL is not valid / experiment not found.'
      redirect_to '/dashboard/experiment/index'
    ensure
      @experiment.name = params[:experiment][:name]
      @experiment.tags = params[:experiment][:tags]
      @experiment.expiry_date = params[:experiment][:expiry_date]
      @experiment.save!

      flash[:notice] = "Sample successfully changed!"
      redirect_to "/dashboard/experiments/#{@experiment.id}"
    end
  end

  def sample_edit

  end

  private

  def experiment_params
    params.require(:experiment).permit(:name, :tags, :expiry_date)
  end
end
