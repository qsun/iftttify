require 'test_helper'
require 'minitest/mock'

class PagesControllerTest < ActionController::TestCase
  def setup
    @new_post_with_correct_auth = '<?xml version="1.0" encoding="UTF-8"?>
<methodCall>
   <methodName>metaWeblog.newPost</methodName>
   <params>
      <param>
         <value>
            <string>MyBlog</string>
         </value>
      </param>
      <param>
         <value>
            <string>username</string>
         </value>
      </param>
      <param>
         <value>
            <string>password</string>
         </value>
      </param>
      <param>
         <value>
            <struct>
               <member>
                  <name>title</name>
                  <value>
                     <string>My Title</string>
                  </value>
               </member>
               <member>
                  <name>description</name>
                  <value>
                     <string>My description</string>
                  </value>
               </member>
               <member>
                  <name>categories</name>
                  <value>
                     <array>
                        <data>
                           <value>
                              <string>My Category</string>
                          </value>
                        </data>
                     </array>
                  </value>
               </member>
            </struct>
         </value>
      </param>
      <param>
         <value>
            <boolean>1</boolean>
         </value>
      </param>
   </params>
</methodCall>'
    @new_post_with_incorrect_auth = '<?xml version="1.0" encoding="UTF-8"?>
<methodCall>
   <methodName>metaWeblog.newPost</methodName>
   <params>
      <param>
         <value>
            <string>MyBlog</string>
         </value>
      </param>
      <param>
         <value>
            <string>u</string>
         </value>
      </param>
      <param>
         <value>
            <string>p</string>
         </value>
      </param>
      <param>
         <value>
            <struct>
               <member>
                  <name>title</name>
                  <value>
                     <string>My Title</string>
                  </value>
               </member>
               <member>
                  <name>description</name>
                  <value>
                     <string>My description</string>
                  </value>
               </member>
               <member>
                  <name>categories</name>
                  <value>
                     <array>
                        <data>
                           <value>
                              <string>My Category</string>
                          </value>
                        </data>
                     </array>
                  </value>
               </member>
            </struct>
         </value>
      </param>
      <param>
         <value>
            <boolean>1</boolean>
         </value>
      </param>
   </params>
</methodCall>'

  end
  test "should respond to mt.supportedMethods" do
    raw_post :ifttt, {format: :xml}, '<?xml version="1.0"?>
<methodCall>
  <methodName>mt.supportedMethods</methodName>
</methodCall>
'
    assert_response 200
    assert_match /metaWeblog.getRecentPosts/, @response.body
  end

  test "should respond to metaWeblog.getRecentPosts" do
    raw_post :ifttt, {format: :xml}, '<?xml version="1.0"?>
<methodCall>
  <methodName>metaWeblog.getRecentPosts</methodName>
</methodCall>
'
    assert_response 200
  end

  test "should deny unauthorized access to metaWeblog.newPost" do
    raw_post :ifttt_auth, {format: :xml}, @new_post_with_incorrect_auth
    assert_response 401
  end

  test "should accept authorized access to metaWeblog.newPost" do
    raw_post :ifttt_auth, {format: :xml}, @new_post_with_correct_auth
    assert_response 200
    assert_match /42/, @response.body
  end

  test "should accept metaWeblog.newPost if no credential specified" do
    raw_post :ifttt, {format: :xml}, @new_post_with_incorrect_auth
    assert_response 200
    assert_match /42/, @response.body
  end

  test "should pass proper post to method" do
    raw_post :ifttt, {format: :xml}, @new_post_with_correct_auth
    post = @controller.post
    assert_equal("MyBlog", post.blog_name)
    assert_equal("username", post.username)
    assert_equal("password", post.password)
    assert_equal("My description", post.body)
    assert_equal("My Title", post.title)
  end
end
