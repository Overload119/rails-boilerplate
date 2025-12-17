# typed: false
# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Todos", :inertia) do
  describe "GET /todos (index)" do
    it "returns Inertia response with todos" do
      todo1 = create(:todo, position: 1)
      todo2 = create(:todo, position: 2)

      get todos_path

      expect(response).to(have_http_status(:ok))
      expect_inertia.to(render_component("Todos/Index"))
      expect_inertia.to(include_props(
        todos: array_including(
          hash_including(id: todo1.id),
          hash_including(id: todo2.id),
        ),
      ))
    end

    it "returns ordered todos" do
      todo2 = create(:todo, position: 2)
      todo1 = create(:todo, position: 1)

      get todos_path

      expect_inertia.to(include_props(
        todos: [
          hash_including(id: todo1.id),
          hash_including(id: todo2.id),
        ],
      ))
    end
  end

  describe "POST /todos (create)" do
    context "with valid parameters" do
      it "creates a new todo and redirects" do
        expect do
          post(todos_path, params: { todo: { title: "New todo" } })
        end.to(change(Todo, :count).by(1))

        expect(response).to(redirect_to(todos_path))
        follow_redirect!
        expect(flash[:notice]).to(eq("Todo created successfully!"))
      end
    end

    context "with invalid parameters" do
      it "redirects with error for blank title" do
        post todos_path, params: { todo: { title: "" } }

        expect(response).to(redirect_to(todos_path))
        follow_redirect!
        expect(flash[:alert]).to(include("Title can't be blank"))
      end
    end
  end

  describe "PATCH /todos/:id (update)" do
    let!(:todo) { create(:todo, title: "Original title") }

    it "updates the todo and redirects" do
      patch todo_path(todo), params: { todo: { title: "Updated title" } }

      expect(response).to(redirect_to(todos_path))
      expect(todo.reload.title).to(eq("Updated title"))
    end
  end

  describe "DELETE /todos/:id (destroy)" do
    let!(:todo) { create(:todo) }

    it "deletes the todo and redirects" do
      expect do
        delete(todo_path(todo))
      end.to(change(Todo, :count).by(-1))

      expect(response).to(redirect_to(todos_path))
    end
  end

  describe "PATCH /todos/:id/toggle" do
    let!(:todo) { create(:todo, completed: false) }

    it "toggles the completed status" do
      patch toggle_todo_path(todo)

      expect(response).to(redirect_to(todos_path))
      expect(todo.reload.completed).to(be(true))
    end
  end

  describe "DELETE /todos/clear_completed" do
    let!(:active_todo) { create(:todo, :active) }
    let!(:completed_todo) { create(:todo, :completed) }

    it "deletes all completed todos" do
      expect do
        delete(clear_completed_todos_path)
      end.to(change(Todo, :count).by(-1))

      expect(response).to(redirect_to(todos_path))
      expect(Todo.exists?(completed_todo.id)).to(be(false))
      expect(Todo.exists?(active_todo.id)).to(be(true))
    end
  end
end
