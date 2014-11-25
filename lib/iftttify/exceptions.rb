module Iftttify
  module Exceptions
    class IftttifyError < StandardError; end

    class InvalidCredential < IftttifyError; end
    class InvalidMethod < IftttifyError; end
  end
end
