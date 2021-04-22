# frozen_string_literal: true

class TodosService
  attr_reader :user, :params

  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def list_all
    todos =
      case params[:status]&.strip&.downcase
      when 'overdue' then Todo.overdue
      when 'completed' then Todo.completed
      when 'uncompleted' then Todo.uncompleted
      else Todo.all
      end

    todos.where(user_id: user.id).map(&:serialize_as_json)
  end

  def create_todo
    user.todos.create(todo_params(params))
  end

  def find_todo
    user.todos.find(params[:id])
  end

  def destroy_todo
    todo = find_todo
    todo.destroy
    todo
  end

  def update_todo
    todo = find_todo

    todo.update(todo_params(params))

    todo
  end

  def complete_todo
    todo = find_todo

    todo.completed_at = Time.current unless todo.completed?

    todo.save if todo.completed_at_changed?

    todo
  end

  def uncomplete_todo
    todo = find_todo

    todo.completed_at = nil unless todo.uncompleted?

    todo.save if todo.completed_at_changed?

    todo
  end

  private

    def todo_params(arg)
      params = arg.is_a?(ActionController::Parameters) ? arg : ActionController::Parameters.new(arg)

      params.require(:todo).permit(:title, :due_at)
    end
end
