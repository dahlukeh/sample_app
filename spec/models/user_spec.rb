require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example guy",
              :email => "me@somewhere.net",
              :password => "thisIsSec",
              :password_confirmation => "thisIsSec"}
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

  describe "password validations" do
      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
      end

      it "should require a matching passwords" do
        User.new(@attr.merge(:password_confirmation => "doesn't match")).
          should_not be_valid
      end

      it "should reject short passwords" do
        short_pw = "a" * 5
        hash = @attr.merge(:password => short_pw, :password_confirmation => short_pw)
        User.new(hash).should_not be_valid
      end

      it "should reject long passwords" do
        long_pw = "a" * 31
        hash = @attr.merge(:password => long_pw, :password_confirmation => long_pw)
        User.new(hash).should_not be_valid
      end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "password checking" do
      it "should be true if the passwords match" do
        @user.correct_password?(@attr[:password]).should be_true
      end

      it "should be false if they don't match" do
        @user.correct_password?("not_correct").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on when they don't match" do
        no_match = User.authenticate(@attr[:email], "bad_pw")
        no_match.should be_nil
      end

      it "should return nil for a non-existant email" do
        no_person = User.authenticate("Some@random.com", @attr[:password])
        no_person.should be_nil
      end

      it "should actually work" do
        guy = User.authenticate(@attr[:email], @attr[:password]);
        guy.should == @user
      end
    end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end


  describe "micropost associations" do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy the associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include other posts" do
        mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end
    end

  end


end

