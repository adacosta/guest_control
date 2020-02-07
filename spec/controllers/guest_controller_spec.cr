require "./spec_helper"

def guest_hash
  {"name" => "Fake", "note" => "Fake", "user_id" => "1"}
end

def guest_params
  params = [] of String
  params << "name=#{guest_hash["name"]}"
  params << "note=#{guest_hash["note"]}"
  params << "user_id=#{guest_hash["user_id"]}"
  params.join("&")
end

def create_guest
  model = Guest.new(guest_hash)
  model.save
  model
end

class GuestControllerTest < GarnetSpec::Controller::Test
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

describe GuestControllerTest do
  subject = GuestControllerTest.new

  it "renders guest index template" do
    Guest.clear
    response = subject.get "/guests"

    response.status_code.should eq(200)
    response.body.should contain("guests")
  end

  it "renders guest show template" do
    Guest.clear
    model = create_guest
    location = "/guests/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Guest")
  end

  it "renders guest new template" do
    Guest.clear
    location = "/guests/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Guest")
  end

  it "renders guest edit template" do
    Guest.clear
    model = create_guest
    location = "/guests/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Guest")
  end

  it "creates a guest" do
    Guest.clear
    response = subject.post "/guests", body: guest_params

    response.headers["Location"].should eq "/guests"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a guest" do
    Guest.clear
    model = create_guest
    response = subject.patch "/guests/#{model.id}", body: guest_params

    response.headers["Location"].should eq "/guests"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a guest" do
    Guest.clear
    model = create_guest
    response = subject.delete "/guests/#{model.id}"

    response.headers["Location"].should eq "/guests"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
