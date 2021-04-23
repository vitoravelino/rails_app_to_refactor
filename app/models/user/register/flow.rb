# frozen_string_literal: true

module User::Register
  class Flow < Micro::Case
    flow([
      Step::NormalizeAttributes,
      Step::ValidateAttributes,
      Step::CreateRecord,
      Step::SerializeAsJson
    ])
  end
end
