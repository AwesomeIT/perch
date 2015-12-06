class Dashboard::ParticipantController < ApplicationController
  def index
    @participants = Participant.last(25).reverse
  end

  def details
    begin
      @participant = Participant.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Participant URL is not valid / participant not found'
      redirect_to '/dashboard/participants/index'
    end
  end

  def reset_pw
    begin
      @participant = Participant.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Something went wrong.'
      redirect_to '/dashboard/participants/index'
    ensure
      @participant.salt = @participant.bcrypt_salt(params[:participant][:password])
      @participant.save!

      flash[:notice] = "Password successfully changed!"
      redirect_to "/dashboard/participants/#{@participant.id}"
    end
  end

end
