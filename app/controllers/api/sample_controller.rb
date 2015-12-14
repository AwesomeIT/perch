class Api::SampleController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Only administrators can have volatile access
  before_action only [:create, :delete, :modify] do
    doorkeeper_authorize! :administrator
  end

  # Only authorized applications can retrieve
  # sample resources

  before_action only [:retrieve_by_id, :retrieve_set, :search] do
    doorkeeper_authorize! :administrator, :client
  end

  def create
    # Validate request
    unless params.has_key?(:s3_url) && params.has_key?(:name) && params.has_key?(:tags)
      @error = Error.create(
          :message => 'No data was provided. Did you set your Content-Type header?',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    # Create sample
    @new_sample = Sample.new(
        :name => params[:name],
        :s3_url => params[:s3_url],
        :tags => params[:tags],
        :expected_score => params[:expected_score]
    )

    # Attempt to save sample
    begin
      @new_sample.save!
    rescue ActiveRecord::RecordInvalid
      @error = Error.create(
          :message => 'Data is improperly formatted. Ensure that name is a string,
            tags is an array, and s3_url is a string.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      render(status: 201, json: @new_sample.id) and return
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

  def modify
    # Validate ID
    unless params.has_key?(:id)
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
    end

    # Edit Sample
    @found_sample.s3_url = params[:s3_url] if params.key?(:s3_url)
    @found_sample.expected_score = params[:expected_score] if params.key?(:expected_score)
    @found_sample.tags = params[:tags] if params.key?(:tags)

    # Attempt to save experiment
    begin
      @found_sample.save!
    rescue ActiveRecord::RecordInvalid
      @error = Error.create(
          :message => 'Data is improperly formatted. Ensure that s3_url is a string,
          expected score is an int and tags is an array.',
          :path => request.env['PATH_INFO'],
          :request => params.to_json
      )
      render(status: 500, json: @error) and return
    ensure
      # Everything is OK
      render(status: 200, nothing: true) and return
    end
  end

  def search
      # Something must be passed in
      unless params.has_key?(:s3_url) or params.has_key?(:date) or params.has_key?(:tags)
        @error = Error.create(
            :message => 'No search parameter was provided.',
            :path => request.env['PATH_INFO'],
            :request => params.to_json
        )
        render(status: 500, json: @error) and return
      end

      @found_samples = []
      if params.has_key?(:s3_url)
        @sample = Sample.find(params[:s3_url])
        render(status: 200, json: @sample) and return
      end

      if params.has_key?(:date)
        @found_samples << Sample.where(created_at (:date.midnight - 1.day)..:date.midnight)
        render(status: 200, json: @found_samples) and return
      end

      if params.has_key?(:tags)
        #@found_samples << Sample.where(not (tags & :tags).empty)
        render(status: 200, json: @found_samples)
      end
  end
end
