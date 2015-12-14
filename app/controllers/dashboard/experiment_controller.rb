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

      @chart_score_data = ''

      @experiment.scores.each do |score|
        if @chart_score_data.blank?
          @chart_score_data << score.rating.to_s
        else
          @chart_score_data << ',' << score.rating.to_s
        end
      end

    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Experiment URL is not valid / experiment not found.'
      redirect_to '/dashboard/experiments/index'
    end
  end

  def edit

  end

  def sample_edit

  end

  private

  def experiment_params
    params.require(:experiment).permit(:name, :tags, :expiry_date)
  end
end
