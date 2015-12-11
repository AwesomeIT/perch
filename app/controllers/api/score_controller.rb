class Api::ScoreController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action do
    doorkeeper_authorize! :administrator, :client
  end

  def create
    # Validate request
    unless params.has_key?(:participant_id) && params.has_key?(:sample_id) \
        && params.has_key?(:rating) && params.has_key?(:experiment_id)
      @error = Error.create(
          :message => 'Missing data, must have experiment id, participant id, sample id, and rating.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    #Find participant and sample to ensure valid ids
    begin
      @found_participant = Participant.find(params[:participant_id])
      @found_experiment = Experiment.find(params[:experiment_id])
      @found_sample = Sample.find(params[:sample_id])
    rescue ActiveRecord::RecordNotFound
      @error = Error.create(
          :message => 'ID not found.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    # Create score
    @new_score = Score.new(
        :participant_id => params[:participant_id],
        :experiment_id => params[:experiment_id],
        :sample_id => params[:sample_id],
        :rating => params[:rating]
    )

    # Attempt to save sample
    begin
      @new_score.save!
    rescue ActiveRecord::RecordInvalid
      @error = Error.create(
          :message => 'Data is improperly formatted.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      render(status: 201, json: @new_score.id) and return
    end
  end

end