require "spec_helper"

feature "homepage" do
  scenario "should have a registration button" do
    visit "/"

    expect(page).to have_link("Register")
  end
end

  feature "register" do
    scenario "should have registration form, and then be able to login" do
    visit "/register"



    expect(page).to have_content("Register")
    end
  end


feature "login" do
  scenario "should let the user login" do
    visit "/"

     fill_in('username', :with => 'hunter')
     fill_in('password', :with => '123')

   click_button 'Login'

    expect(page).to have_content('Welcome, hunter!')
  end
end


