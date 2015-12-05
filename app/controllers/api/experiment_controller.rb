class Api::ExperimentController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Validate request
    unless params.has_key?(:name) \
           && params.has_key?(:tags) \
           && params.has_key?(:samples)
      @error = Error.create(
          :message => 'No data was provided. Did you set your Content-Type header?',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    # Create experiment
    @new_experiment = Experiment.new(
        :name => params[:name],
        :tags => params[:tags],
        :samples => params[:samples],
        :expiry_date => '0'
    )

    # Attempt to save experiment
    begin
      @new_experiment.save!
    rescue ActiveRecord::RecordInvalid
      @error = Error.create(
          :message => 'Data is improperly formatted. Ensure that name is a string,
          tags and samples are arrays.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      render(status: 200, nothing: true) and return
    end
  end

  def modify
    # Validate ID
    unless params.has_key(:id)
      @error = Error.create(
          :message => 'No ID was provided.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    begin
      @found_experiment = Experiment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = Error.create(
          :message => 'ID not found.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    # Edit Experiment
    @found_experiment.name = params[:name] if params.key?(:name)
    @found_experiment.expiry_date = params[:expiry_date] if params.key?(:expiry_date)
    @found_experiment.tags = params[:tags] if params.key?(:tags)

    # Attempt to save experiment
    begin
      @found_experiment.save!
    rescue ActiveRecord::RecordInvalid
      @error = Error.create(
          :message => 'Data is improperly formatted. Ensure that name is a string,
          tags and samples are arrays.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      render(status: 200, nothing: true) and return
    end
  end

  def delete
    # Validate ID
    unless params.has_key(:id)
      @error = Error.create(
          :message => 'No ID was provided.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    begin
      @found_experiment = Experiment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = Error.create(
          :message => 'ID not found.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      @found_experiment.delete!
      render(status: 200, nothing: true) and return
    end
  end

  def retrieve
    # Validate ID
    unless params.has_key(:id)
      @error = Error.create(
          :message => 'No ID was provided.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    begin
      @found_experiment = Experiment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = Error.create(
          :message => 'ID not found.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      render(status: 200, json: @found_experiment) and return
    end
  end
end
