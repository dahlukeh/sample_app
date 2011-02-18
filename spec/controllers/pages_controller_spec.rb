require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => @base_title + " | Home")
    end

    describe "if signed in" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should have a place to create a new micropost" do
        get :home
        response.should have_selector("form.new_micropost", :method => "post")
      end

      it "should have a sidebar" do
        get :home
        response.should have_selector("td", :class => "sidebar round")
      end

      it "should have a sidebar with correct micropost count" do
        correct_text = "#{@user.microposts.count} micropost"
        correct_text += "s" unless @user.microposts.count == 1

        get :home
        response.should have_selector("span.microposts", :content => correct_text)
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", :content => @base_title + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title", :content => @base_title + " | About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title", :content => @base_title + " | Help")
    end
  end
end

