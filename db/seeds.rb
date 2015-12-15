# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env == 'development'
  require 'bcrypt'

  # Create an administrative user to
  # log in with
  User.create(
    :email => 'test@birdfeed.com',
    :password => 'abc123$$$',
    :admin => true
  )

  # Create some participants
  participant_collection = [
    Participant.create(
      :username => 'supercoolguy123',
      :salt => BCrypt::Password.create('notsecure')
    ),
    Participant.create(
      :username => 'superedgytumblr',
      :salt => BCrypt::Password.create('omgnoway')
    ),
    Participant.create(
      :username => 'ireadfoxnews',
      :salt => BCrypt::Password.create('so cool')
    ),
    Participant.create(
      :username => 'somelady333',
      :salt => BCrypt::Password.create('boom')
    )
  ]

  # Create a bushel of samples
  sample_collection = [
      Sample.create(
          :name => 'Some annoying lamp',
          :expected_score => 2.5
      ),
      Sample.create(
          :name => 'Some annoying table',
          :expected_score => 5.5
      ),
      Sample.create(
          :name => 'Some annoying chair',
          :expected_score => 0.5
      ),
      Sample.create(
          :name => 'The word finangle',
          :expected_score => 9.0
      ),
      Sample.create(
          :name => 'The word bamboozled',
          :expected_score => 9.5
      )
  ]

  # Create an experiment (more in future)
  experiment_collection = [
    Experiment.create(
      :name => 'Pronounce IKEA furniture',
      :tag_list => %w(this is impossible)
    )
  ]

  # Populate with 100 random scores from each
  # participant to each experiment and sample
  experiment_collection.each do |experiment|
    participant_collection.each do |participant|
      sample_collection.each do |sample|
        experiment.samples << sample
        for i in 0..45
          Score.create(
             :participant_id => participant.id,
             :experiment_id => experiment.id,
             :sample_id => sample.id,
             :rating => rand(0..10)
          )
        end
      end
    end
  end


end