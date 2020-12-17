class FindTodo < Micro::Case
  attribute :todo_id

  def call!
    todo = Todo.find_by(id: todo_id)

    if todo
      Success result: { todo: todo }
    else
      Failure(:todo_not_found)
    end
  end
end
