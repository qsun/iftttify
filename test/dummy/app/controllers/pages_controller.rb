class PagesController < ApplicationController
  iftttify :ifttt, with: :cb
  iftttify :ifttt_auth, auth: {username: "username", password: "password"}, with: :cb

  def post
    @post
  end

  private
  def cb(post)
    @post = post
    42
  end

end
