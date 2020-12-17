module Todos
  class Complete < Micro::Case
    flow([Find, self])

    attribute :todo

    def call!
      unless todo.completed?
        todo.update_attribute(:completed_at, Time.current)
      end

      Success result: { todo: todo }
    end
  end
end
