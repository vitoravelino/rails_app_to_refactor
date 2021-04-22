# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :authenticate_user

  rescue_from ActiveRecord::RecordNotFound do
    render_json(404, todo: { id: 'not found' })
  end

  def index
    json = todos_service.list_all(user: current_user, params: params)

    render_json(200, todos: json)
  end

  def create
    todo = todos_service.create_todo(user: current_user, params: params)

    if todo.valid?
      render_json(201, todo: todo.serialize_as_json)
    else
      render_json(422, todo: todo.errors.as_json)
    end
  end

  def show
    todo = todos_service.find_todo(user: current_user, params: params)

    render_json(200, todo: todo.serialize_as_json)
  end

  def destroy
    todo = todos_service.destroy_todo(user: current_user, params: params)

    render_json(200, todo: todo.serialize_as_json)
  end

  def update
    todo = todos_service.update_todo(user: current_user, params: params)

    if todo.valid?
      render_json(200, todo: todo.serialize_as_json)
    else
      render_json(422, todo: todo.errors.as_json)
    end
  end

  def complete
    todo = todos_service.complete_todo(user: current_user, params: params)

    render_json(200, todo: todo.serialize_as_json)
  end

  def uncomplete
    todo = todos_service.uncomplete_todo(user: current_user, params: params)

    render_json(200, todo: todo.serialize_as_json)
  end

  private

    def todos_service
      TodosService.new
    end
end
