# typed: false
# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :set_todo, only: [:update, :destroy, :toggle]

  # GET /todos (also root path)
  def index
    @todos = Todo.ordered

    render(inertia: "Todos/Index", props: {
      todos: @todos.as_json(only: [:id, :title, :completed, :position, :created_at, :updated_at]),
    })
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      redirect_to(todos_path, notice: "Todo created successfully!")
    else
      redirect_to(todos_path, alert: @todo.errors.full_messages.join(", "))
    end
  end

  # PATCH/PUT /todos/:id
  def update
    if @todo.update(todo_params)
      redirect_to(todos_path, notice: "Todo updated successfully!")
    else
      redirect_to(todos_path, alert: @todo.errors.full_messages.join(", "))
    end
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy!
    redirect_to(todos_path, notice: "Todo deleted successfully!")
  end

  # PATCH /todos/:id/toggle
  def toggle
    @todo.toggle!
    redirect_to(todos_path)
  end

  # DELETE /todos/clear_completed
  def clear_completed
    count = Todo.completed.destroy_all.count
    redirect_to(todos_path, notice: "Cleared #{count} completed todo#{"s" if count != 1}!")
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.expect(todo: [:title, :completed, :position])
  end
end
