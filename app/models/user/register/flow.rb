# frozen_string_literal: true

module User::Register
  class Flow < Micro::Case
    def call!
      transaction {
        call(Step::NormalizeAttributes)
          .then(Step::ValidateAttributes)
          .then(Step::CreateRecord)
      }
      .then(Step::SerializeAsJson)
    end
  end
end
