class Todos::SerializeAsJson < Micro::Case
  attribute :todo

  def call!
    json = todo.as_json(except: [:user_id], methods: :status)

    Success(result: {todo_as_json: json})
  end
end
