class Api::ScoresController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Validate request
    unless params.has_key?(:participant_id) && params.has_key?(:sample_id) && params.has_key?(:rating)
      @error = Error.create(
          :message => 'Missing data, must have participant id, sample id, and rating.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    #Find participant and sample to ensure valid ids
    begin
      @found_participant = Participant.find(params[:participant_id])
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
      render(status: 200, nothing: true) and return
    end
  end

end