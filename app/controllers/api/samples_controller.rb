class Api::SamplesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Validate request
    unless params.has_key?(:filename) \
           && params.has_key?(:data)
      @error = Error.create(
          :message => 'No data was provided. Did you set your Content-Type header?',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    # Create sample
    @new_sample = Sample.new(
        :filename => params[:filename],
        :data => params[:data]
    )

    # Attempt to save sample
    begin
      @new_sample.save!
    rescue ActiveRecord::RecordInvalid
      @error = Error.create(
          :message => 'Data is improperly formatted. Ensure that filename is a string
            and data is a raw uncompressed audio sample.',
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
      @found_sample = Sample.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = Error.create(
          :message => 'ID not found.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      @found_sample.delete!
      render(status: 200, nothing: true) and return
    end
  end

  def retrieve_by_id
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
      @found_sample = Sample.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = Error.create(
          :message => 'ID not found.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      render(status: 200, json: @found_sample) and return
    end
  end

  def retrieve_set
    @found_samples = []
    for id in params[:ids] do
      @found_samples << Sample.find(id)
    end
    render(status: 200, json: @found_samples)
  end

  def retrieve
    @num_samples = 10
    if params.has_key?(:limit)
      @num_samples = params[:limit]
    end
    @found_samples = Sample.last(@num_samples)
    render(status: 200, json: @found_samples)
  end

end
