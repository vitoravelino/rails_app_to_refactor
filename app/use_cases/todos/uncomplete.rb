module Todos
  class Uncomplete < Micro::Case
    flow([Find, self])

    attribute :todo

    def call!
      unless todo.uncompleted?
        todo.update_attribute(:completed_at, nil)
      end

      Success result: { todo: todo }
    end
  end
end
