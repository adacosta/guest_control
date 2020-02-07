require "./spec_helper"

def remote_credentials_hash
  {"user_id" => "1", "username" => "Fake", "encrypted_password" => "Fake"}
end

def remote_credentials_params
  params = [] of String
  params << "user_id=#{remote_credentials_hash["user_id"]}"
  params << "username=#{remote_credentials_hash["username"]}"
  params << "encrypted_password=#{remote_credentials_hash["encrypted_password"]}"
  params.join("&")
end

def create_remote_credentials
  model = RemoteCredential.new(remote_credentials_hash)
  model.save
  model
end

class RemoteCredentialsControllerTest < GarnetSpec::Controller::Test
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

describe RemoteCredentialsControllerTest do
  subject = RemoteCredentialsControllerTest.new

  it "renders remote_credentials index template" do
    RemoteCredential.clear
    response = subject.get "/remote_credentials"

    response.status_code.should eq(200)
    response.body.should contain("remote_credentials")
  end

  it "renders remote_credentials show template" do
    RemoteCredential.clear
    model = create_remote_credentials
    location = "/remote_credentials/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Remote Credential")
  end

  it "renders remote_credentials new template" do
    RemoteCredential.clear
    location = "/remote_credentials/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Remote Credential")
  end

  it "renders remote_credentials edit template" do
    RemoteCredential.clear
    model = create_remote_credentials
    location = "/remote_credentials/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Remote Credential")
  end

  it "creates a remote_credentials" do
    RemoteCredential.clear
    response = subject.post "/remote_credentials", body: remote_credentials_params

    response.headers["Location"].should eq "/remote_credentials"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a remote_credentials" do
    RemoteCredential.clear
    model = create_remote_credentials
    response = subject.patch "/remote_credentials/#{model.id}", body: remote_credentials_params

    response.headers["Location"].should eq "/remote_credentials"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a remote_credentials" do
    RemoteCredential.clear
    model = create_remote_credentials
    response = subject.delete "/remote_credentials/#{model.id}"

    response.headers["Location"].should eq "/remote_credentials"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
