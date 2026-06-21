# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Designer", :db do
  let(:model) { Factory[:model] }
  let(:template) { Factory[:screen_template, model_id: model.id] }

  before { template }

  it "views index" do
    visit routes.path(:designs)
    expect(page).to have_text(template.label)
  end

  it "creates", :aggregate_failures, :js do
    visit routes.path(:designs)
    click_link "New"
    select model.label, from: "template[model_id]"
    click_button "Save"

    expect(page).to have_text("must be filled")

    fill_in "template[label]", with: "Test"
    fill_in "template[name]", with: "test"
    click_button "Save"

    expect(page).to have_text("Edit Design")
  end

  it "edits", :js do
    visit routes.path(:design_edit, id: template.id)
    expect(page).to have_text("Edit Design")
  end

  it "edits and displays error", :js do
    visit routes.path(:design_edit, id: template.id)
    fill_in "template[label]", with: nil
    click_button "Save"

    expect(page).to have_text("must be filled")
  end

  it "deletes", :js do
    visit routes.path(:designs)
    accept_prompt { click_button "Delete" }

    expect(page).to have_no_text(template.label)
  end
end
