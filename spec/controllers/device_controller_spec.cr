require "./spec_helper"

def device_hash
  {"serial_number" => "Fake", "family" => "Fake", "platform" => "Fake", "type" => "Fake", "remote_created_at" => "2020-01-04 05:51:36 UTC", "state" => "Fake", "remote_credential_id" => "1"}
end

def device_params
  params = [] of String
  params << "serial_number=#{device_hash["serial_number"]}"
  params << "family=#{device_hash["family"]}"
  params << "platform=#{device_hash["platform"]}"
  params << "type=#{device_hash["type"]}"
  params << "remote_created_at=#{device_hash["remote_created_at"]}"
  params << "state=#{device_hash["state"]}"
  params << "remote_credential_id=#{device_hash["remote_credential_id"]}"
  params.join("&")
end

def create_device
  model = Device.new(device_hash)
  model.save
  model
end

class DeviceControllerTest < GarnetSpec::Controller::Test
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

describe DeviceControllerTest do
  subject = DeviceControllerTest.new

  it "renders device index template" do
    response = subject.get "/devices"

    response.status_code.should eq(200)
    response.body.should contain("devices")
  end

  it "renders device show template" do
    model = create_device
    location = "/devices/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Device")
  end

  it "renders device new template" do
    location = "/devices/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Device")
  end

  it "renders device edit template" do
    model = create_device
    location = "/devices/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Device")
  end

  it "creates a device" do
    response = subject.post "/devices", body: device_params

    response.headers["Location"].should eq "/devices"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a device" do
    model = create_device
    response = subject.patch "/devices/#{model.id}", body: device_params

    response.headers["Location"].should eq "/devices"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a device" do
    model = create_device
    response = subject.delete "/devices/#{model.id}"

    response.headers["Location"].should eq "/devices"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
