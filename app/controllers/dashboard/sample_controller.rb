class Dashboard::SampleController < ApplicationController
  def index
    @samples = Sample.paginate(:page => params[:page], :per_page => 15)
  end

  def create

  end

  def process_create
    check_params = sample_params

    unless check_params[:expected_score]
      check_params[:expected_score] = -1
    end

    Sample.new(check_params)

    redirect_to '/dashboard/samples/index'
  end

  def details
    begin
      @sample = Sample.find(params[:id])

      @chart_score_rating = ''
      @chart_score_id = ''

      @sample.scores.each do |score|
        if @chart_score_rating.blank?
          @chart_score_rating << score.rating.to_s
          @chart_score_id << score.id.to_s
        else
          @chart_score_rating << ',' << score.rating.to_s
          @chart_score_id << ',' << score.id.to_s
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Sample URL is not valid / sample not found.'
      redirect_to '/dashboard/samples/index'
    end
  end

  def edit
    begin
      @sample = Sample.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Participant URL is not valid / participant not found.'
      redirect_to '/dashboard/samples/index'
    ensure
      @sample.name = params[:sample][:name]
      @sample.tags = params[:sample][:tags]
      @sample.expected_score = params[:sample][:expected_score]
      @sample.save!

      flash[:notice] = "Sample successfully changed!"
      redirect_to "/dashboard/samples/#{@sample.id}"
    end
  end

  private

  def sample_params
    params.require(:sample).permit(:audio, :name, :tags, :expected_score)
  end

end