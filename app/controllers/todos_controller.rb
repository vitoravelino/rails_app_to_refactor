# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :authenticate_user

  before_action :set_todo, only: %i[show destroy update complete uncomplete]

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  AsJson = -> (todo) do
    Todos::SerializeAsJson.call(todo: todo)[:todo_as_json]
  end

  def index
    todos =
      case params[:status]&.strip&.downcase
      when 'overdue' then Todo.overdue
      when 'completed' then Todo.completed
      when 'uncompleted' then Todo.uncompleted
      else Todo.all
      end

    json =
      todos.where(user_id: current_user.id).map(&AsJson)

    render_json(200, todos: json)
  end

  def create
    todo = current_user.todos.create(todo_params)

    if todo.valid?
      render_json(201, todo: AsJson[todo])
    else
      render_json(422, todo: todo.errors.as_json)
    end
  end

  def show
    Todos::Find
      .call(todo_id: params[:id])
      .then(Todos::SerializeAsJson)
      .on_success { |result| render_todo_as_json(result) }
      .on_failure(:todo_not_found) { render_404 }
  end

  def destroy
    @todo.destroy

    render_json(200, todo: AsJson[@todo])
  end

  def update
    @todo.update(todo_params)

    if @todo.valid?
      render_json(200, todo: AsJson[@todo])
    else
      render_json(422, todo: @todo.errors.as_json)
    end
  end

  def complete
    Todos::Complete
      .call(todo_id: params[:id])
      .then(Todos::SerializeAsJson)
      .on_success { |result| render_todo_as_json(result) }
      .on_failure(:todo_not_found) { render_404 }
  end

  def uncomplete
    Todos::Uncomplete
      .call(todo_id: params[:id])
      .then(Todos::SerializeAsJson)
      .on_success { |result| render_todo_as_json(result) }
      .on_failure(:todo_not_found) { render_404 }
  end

  private

    def todo_params
      params.require(:todo).permit(:title, :due_at)
    end

    def set_todo
      @todo = current_user.todos.find(params[:id])
    end

    def render_404
      render_json(404, todo: { id: 'not found' })
    end

    def render_todo_as_json(result)
      render_json(200, todo: result[:todo_as_json])
    end
end
