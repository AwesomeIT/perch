class Dashboard::ParticipantController < ApplicationController
  def index
    @participants = Participant.last(25).reverse
  end
end
