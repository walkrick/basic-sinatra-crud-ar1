require "spec_helper"

feature "homepage" do
  scenario "should have a registration button" do
    visit "/"

    expect(page).to have_link("Register")
  end

  feature "register" do
    scenario "should have registration form, and then be able to login" do
    visit "/register"

    expect(page).to have_content("Register")
    end
  end

end