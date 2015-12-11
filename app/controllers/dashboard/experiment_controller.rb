class Dashboard::ExperimentController < ApplicationController
  def index
    @experiments = Experiment.paginate(:page => params[:page], :per_page => 15)
  end
end
