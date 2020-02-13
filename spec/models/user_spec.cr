require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  context "with valid attributes" do
    it "creates" do
      user = User.create(email: "test@test.com", password: "BloopBloop")
      puts user.errors.inspect
      user.valid?.should be_true
    end
  end
end
