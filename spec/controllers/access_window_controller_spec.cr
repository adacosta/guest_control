require "./spec_helper"

def access_window_hash
  {"guest_id" => "1", "device_id" => "1", "start_at" => "2020-01-28 21:00:44 UTC", "end_at" => "2020-01-28 21:00:44 UTC"}
end

def access_window_params
  params = [] of String
  params << "guest_id=#{access_window_hash["guest_id"]}"
  params << "device_id=#{access_window_hash["device_id"]}"
  params << "start_at=#{access_window_hash["start_at"]}"
  params << "end_at=#{access_window_hash["end_at"]}"
  params.join("&")
end

def create_access_window
  model = AccessWindow.new(access_window_hash)
  model.save
  model
end

class AccessWindowControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :web do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
      plug Amber::Pipe::Flash.new
    end
    @handler.prepare_pipelines
  end
end

describe AccessWindowControllerTest do
  subject = AccessWindowControllerTest.new

  it "renders access_window index template" do
    AccessWindow.clear
    response = subject.get "/access_windows"

    response.status_code.should eq(200)
    response.body.should contain("access_windows")
  end

  it "renders access_window show template" do
    AccessWindow.clear
    model = create_access_window
    location = "/access_windows/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Access Window")
  end

  it "renders access_window new template" do
    AccessWindow.clear
    location = "/access_windows/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Access Window")
  end

  it "renders access_window edit template" do
    AccessWindow.clear
    model = create_access_window
    location = "/access_windows/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Access Window")
  end

  it "creates a access_window" do
    AccessWindow.clear
    response = subject.post "/access_windows", body: access_window_params

    response.headers["Location"].should eq "/access_windows"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a access_window" do
    AccessWindow.clear
    model = create_access_window
    response = subject.patch "/access_windows/#{model.id}", body: access_window_params

    response.headers["Location"].should eq "/access_windows"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a access_window" do
    AccessWindow.clear
    model = create_access_window
    response = subject.delete "/access_windows/#{model.id}"

    response.headers["Location"].should eq "/access_windows"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
