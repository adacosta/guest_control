class HomeController < ApplicationController
  def index
    TestWorker.async.perform(1_i64)
    render("index.ecr")
  end
end
