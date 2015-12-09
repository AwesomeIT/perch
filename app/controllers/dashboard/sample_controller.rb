class Dashboard::SampleController < ApplicationController
  def index
    @samples = Sample.last(25).reverse
  end

  def create

  end

  def create_sample
    Api::SampleController.create
  end

end