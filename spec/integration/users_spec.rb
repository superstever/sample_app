require 'spec_helper'

describe "Users" do
  describe "signup" do
    
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_url
          click_button
          response.should render_template('new')
          response.should have_tag("div#errorExplanation")
        end.should_not change(User, :count)
      end #should not make a new user
    end #end "Failure"
    
    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_url
          fill_in "Name",           :with => "Example User"
          fill_in "Email",          :with => "user@example.com"
          fill_in "Password",       :with => "foobar"
          fill_in "Confirmation",   :with => "foobar"
          click_button
          response.should render_template('users/show')
          response.should have_tag("div.flash.success")
        end.should change(User, :count).by(1)
      end #end "should make new user"
    end #end "success"
 
  end #end "Signup"
  
  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        response.should render_template('sessions/new')
        response.should have_tag("div.flash.error", /invalid/i)
      end
    end #end "failure" (from <sign in/out>)
  
    describe "success" do
      it "should sign a user in and out" do
       user = Factory(:user)
        integration_sign_in(user)
        controller.should be_signed_in
        click_link  "Sign out"
        controller.should_not be_signed_in
      end
    end #end "success" (from <sign in/out>)
  end #end "sign in/out"
  

  describe "sign in/out/in" do
    describe "failure" do
      it "should not fail sign-in again after I sign out" do
       user = Factory(:user)
       integration_sign_in(user)
       controller.should be_signed_in
       click_link  "Sign out"
       controller.should_not be_signed_in
       click_link "Sign in"
       fill_in :email, :with => user.email
       fill_in :password, :with => user.password
       click_button
       controller.should be_signed_in
      end
    end #end "failure" (from "sign in/out/in")
  end #end "sign in/out/in"
  
end #end "Users"
