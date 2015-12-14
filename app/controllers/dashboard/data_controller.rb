require 'csv'

class Dashboard::DataController < ApplicationController
  def index
  end

  def csv
    if params.key?(:csv_score_by_sample_id)

      sample = Sample.find(params[:csv_score_by_sample_id][:sample_id])
      send_data sample.scores.as_csv, :type => 'text/csv', :filename => "ScoreBySmp-#{Date.today}.csv"

    elsif params.key?(:csv_score_by_experiment_id)

      experiment = Experiment.find(params[:csv_score_by_experiment_id][:experiment_id])
      send_data experiment.scores.as_csv, :type => 'text/csv', :filename => "ScoreByExp-#{Date.today}.csv"

    elsif params.key?(:csv_experiment_by_participant_id)

      participant = Participant.find(params[:csv_experiment_by_participant_id][:participant_id])
      send_data participant.experiments.as_csv, :type => 'text/csv', :filename => "ExpByPtcp-#{Date.today}.csv"

    elsif params.key?(:csv_experiment_by_sample_id)

      sample = Sample.find(params[:csv_experiment_by_sample_id][:sample_id])
      send_data sample.experiments.as_csv, :type => 'text/csv', :filename => "ExpBySamp-#{Date.today}.csv"

    elsif params.key?(:csv_participant_by_experiment_id)

      experiment = Experiment.find(params[:csv_participant_by_experiment_id][:experiment_id])
      send_data experiment.participants.as_csv, :type => 'text/csv', :filename => "PtcpByExp-#{Date.today}.csv"

    elsif params.key?(:csv_participant_by_sample_id)

      sample = Sample.find(params[:csv_participant_by_sample_id][:sample_id])
      send_data sample.participants.as_csv, :type => 'text/csv', :filename => "PtcpBySamp-#{Date.today}.csv"
    end
  end
end
