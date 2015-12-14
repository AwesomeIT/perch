class Dashboard::ParticipantController < ApplicationController
  def index
    @participants = Participant.paginate(:page => params[:page], :per_page => 15)
  end

  def details
    begin
      @participant = Participant.find(params[:id])

      @chart_score_rating = ''
      @chart_score_id = ''

      @participant.scores.each do |score|
        if @chart_score_rating.blank?
          @chart_score_rating << score.rating.to_s
          @chart_score_id << score.id.to_s
        else
          @chart_score_rating << ',' << score.rating.to_s
          @chart_score_id << ',' << score.id.to_s
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Participant URL is not valid / participant not found.'
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
