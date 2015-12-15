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

      flash[:notice] = "Experiment successfully changed!"
      redirect_to "/dashboard/experiments/#{@experiment.id}"
    end
  end

  def sample_edit
    begin
      @experiment = Experiment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Experiment URL is not valid / experiment not found.'
      redirect_to '/dashboard/experiment/index'
    ensure
    params[:experiment_samples][:id].each do |sample_id|
      unless sample_id.blank?
        @experiment.samples << Sample.find(sample_id)
      end
    end
    @experiment.save!

      flash[:notice] = "Experiment successfully changed!"
      redirect_to "/dashboard/experiments/#{@experiment.id}"
    end
  end

  def sample_delete
    begin
      @experiment = Experiment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Experiment URL is not valid / experiment not found.'
      redirect_to '/dashboard/experiment/index'
    ensure
      params[:experiment_samples][:id].each do |sample_id|
        unless sample_id.blank?
          @experiment.samples.delete(Sample.find(sample_id))
        end
      end
      @experiment.save!

      flash[:notice] = "Experiment successfully changed!"
      redirect_to "/dashboard/experiments/#{@experiment.id}"
    end
  end

  private

  def experiment_params
    params.require(:experiment).permit(:name, :tags, :expiry_date)
  end

  def experiment_sample_params
    params.require(:experiment_samples).permit(:id)
  end
end
