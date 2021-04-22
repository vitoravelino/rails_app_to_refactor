# frozen_string_literal: true

class TodosService
  def list_all(user:, params:)
    todos =
      case params[:status]&.strip&.downcase
      when 'overdue' then Todo.overdue
      when 'completed' then Todo.completed
      when 'uncompleted' then Todo.uncompleted
      else Todo.all
      end

    todos.where(user_id: user.id).map(&:serialize_as_json)
  end

  def create_todo(user:, params:)
    user.todos.create(todo_params(params))
  end

  def find_todo(user:, params:)
    user.todos.find(params[:id])
  end

  def destroy_todo(user:, params:)
    todo = find_todo(user: user, params: params)
    todo.destroy
    todo
  end

  def update_todo(user:, params:)
    todo = find_todo(user: user, params: params)

    todo.update(todo_params(params))

    todo
  end

  def complete_todo(user:, params:)
    todo = find_todo(user: user, params: params)

    todo.completed_at = Time.current unless todo.completed?

    todo.save if todo.completed_at_changed?

    todo
  end

  def uncomplete_todo(user:, params:)
    todo = find_todo(user: user, params: params)

    todo.completed_at = nil unless todo.uncompleted?

    todo.save if todo.completed_at_changed?

    todo
  end

  private

    def todo_params(params)
      params.require(:todo).permit(:title, :due_at)
    end
end
