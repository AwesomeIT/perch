require 'json'
require 'bcrypt'

class Api::ParticipantController < ApplicationController
  skip_before_action :verify_authenticity_token

  def register
    p params
    # Validate request
    unless params.has_key?(:username) && params.has_key?(:password)
      @error = Error.create(
        :message => 'No data was provided. Did you set your Content-Type header?',
        :path => request.env['PATH_INFO'],
        :request => params.to_json
      )
      render(status: 500, json: @error) and return
    end

    # Create participant
    @new_participant = Participant.new(
      :username => params[:username],
      :salt => BCrypt::Password.create(params[:password])
    )

    # Attempt to save participant
    begin
      @new_participant.save!
    rescue ActiveRecord::RecordInvalid
      @error = Error.create(
          :message => 'Invalid username or password provided. Username may already be taken.',
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
