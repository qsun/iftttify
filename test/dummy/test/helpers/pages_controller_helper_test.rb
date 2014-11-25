require 'test_helper'
def raw_post(action, params, body)
  @request.env['RAW_POST_DATA'] = body
  response = post(action, params)
  @request.env.delete('RAW_POST_DATA')
  response
end

class PagesControllerHelperTest < ActionView::TestCase
end
