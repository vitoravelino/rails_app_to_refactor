module Todos
  class Find < Micro::Case
    attribute :user
    attribute :todo_id

    def call!
      todo = user.todos.find_by(id: todo_id)

      if todo
        Success result: { todo: todo }
      else
        Failure(:todo_not_found)
      end
    end
  end
end
