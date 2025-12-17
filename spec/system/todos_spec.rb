# typed: false
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Todos", type: :system do
  before do
    Todo.destroy_all
  end

  describe "visiting the home page" do
    it "shows the todo app" do
      visit root_path

      expect(page).to have_selector("h1", text: "todos")
      expect(page).to have_selector("input[placeholder='What needs to be done?']")
    end
  end

  describe "creating a new todo" do
    it "adds the todo to the list" do
      visit root_path

      fill_in "What needs to be done?", with: "Buy groceries"
      click_button "Add"

      expect(page).to have_selector("span", text: "Buy groceries", wait: 5)
    end
  end

  describe "toggling a todo completion" do
    it "marks the todo as completed" do
      create(:todo, title: "Test todo", completed: false)

      visit root_path

      # Radix UI renders checkbox as button with role="checkbox"
      find("button[role='checkbox']").click

      expect(page).to have_selector("span.line-through", text: "Test todo", wait: 5)
    end
  end

  describe "deleting a todo" do
    it "removes the todo from the list" do
      create(:todo, title: "Todo to delete", completed: false)

      visit root_path

      expect(page).to have_selector("span", text: "Todo to delete")

      # Hover to reveal the delete button (hidden until hover)
      find("span", text: "Todo to delete").hover

      find("[data-testid='delete-todo']").click

      expect(page).not_to have_selector("span", text: "Todo to delete", wait: 5)
    end
  end

  describe "filtering todos" do
    let!(:active_todo) { create(:todo, :active, title: "Active todo") }
    let!(:completed_todo) { create(:todo, :completed, title: "Completed todo") }

    it "shows all todos by default" do
      visit root_path

      expect(page).to have_selector("span", text: "Active todo")
      expect(page).to have_selector("span", text: "Completed todo")
    end

    it "filters to active todos only" do
      visit root_path

      click_button "Active"

      expect(page).to have_selector("span", text: "Active todo")
      expect(page).not_to have_selector("span", text: "Completed todo")
    end

    it "filters to completed todos only" do
      visit root_path

      click_button "Completed"

      expect(page).not_to have_selector("span", text: "Active todo")
      expect(page).to have_selector("span", text: "Completed todo")
    end

    it "shows all todos when clicking All" do
      visit root_path

      click_button "Completed"
      click_button "All"

      expect(page).to have_selector("span", text: "Active todo")
      expect(page).to have_selector("span", text: "Completed todo")
    end
  end
end
