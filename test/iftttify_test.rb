require 'test_helper'

class IftttifyTest < ActiveSupport::TestCase
  test "member_hash_to_hash" do
    h = [{"name"=>"title", "value"=>{"string"=>"My Title"}},
         {"name"=>"description", "value"=>{"string"=>"My description"}},
         {"name"=>"categories", "value"=>{"array"=>{"data"=>{"value"=>{"string"=>"My Category"}}}}}]
         
    result = Iftttify::members_to_hash(h)
    assert_equal("My Title", result[:title])
    assert_equal("My description", result[:description])
  end
end
