require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example guy", :email => "me@somewhere.net" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name = User.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "should require an email" do
    no_email = User.new(@attr.merge(:email => ""))
    no_email.should_not be_valid
  end

  it "should reject names that are over 50" do
    long_name = "z" * 51
    long_guy = User.new(@attr.merge(:name => long_name))
    long_guy.should_not be_valid
  end

  it "should accept names that are 50 long" do
    not_so_long = "z" * 50
    long_guy = User.new(@attr.merge(:name => not_so_long))
    long_guy.should be_valid
  end

  it "should accept valid emails" do
    addresses = %w[user@so.com THE_GUY@some.geY.net what.last@so.j M@m.x]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid emails" do
    addresses = %w[user@so THE_GUY@some,gey what*last@so.j M@m.]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate emails" do
    User.create!(@attr)
    user_dup = User.new(@attr)
    user_dup.should_not be_valid
  end

  it "should reject duplicate emails in any case" do
    upper_case = @attr[:email].upcase
    User.create!(@attr.merge(:email => upper_case))
    user_dup = User.new(@attr)
    user_dup.should_not be_valid
  end
end

