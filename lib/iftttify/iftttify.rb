require 'ostruct'

module Iftttify
  Post = Struct.new :blog_name, :username, :password, :title, :body
  
  def self.process(request, options, &block)
    
    r = Hash.from_xml(request.body.read)
    
    methodName = r["methodCall"]["methodName"]

    if methodName == 'mt.supportedMethods'
      'metaWeblog.getRecentPosts'
    elsif methodName == 'metaWeblog.getRecentPosts'
      '<array><data></data></array>'
    elsif methodName == 'metaWeblog.newPost'
      username = r["methodCall"]["params"]["param"][1]["value"]["string"]
      password = r["methodCall"]["params"]["param"][2]["value"]["string"]
      if !options[:auth] || (options[:auth][:username] == username) && (options[:auth][:password] == password)
        h = Iftttify::members_to_hash(r["methodCall"]["params"]["param"][3]["value"]["struct"]["member"])
        result = block.call Post.new(
                                     r["methodCall"]["params"]["param"][0]["value"]["string"],
                                     username,
                                     password,
                                     h[:title],
                                     h[:description]
                                     )
        result
      else
        raise Iftttify::Exceptions::InvalidCredential, "Failed to verify credential provided: [#{username}] with [#{password}]"
      end
    else
      raise Iftttify::Exceptions::InvalidMethod, "Failed to recognize #{methodName}"
    end
  end

  def self.members_to_hash(members)
    h = Hash.new
    members.each do |kv|
      if kv["value"]["string"]
        h[kv["name"].to_sym] = kv["value"]["string"]
      end
    end
    h
  end

  module ActAsIFTTT
    extend ActiveSupport::Concern

    included do
    end
    
    module ClassMethods
      def iftttify(method, options = {})
        send(:define_method, method) do
          begin
            response = Iftttify.process request, options do |post|
              send(options[:with], post)
            end

            render text: "<?xml version=\"1.0\"?><methodResponse><params><param><value>#{response}</value></param></params></methodResponse>", content_type: 'application/xml'
          rescue Iftttify::Exceptions::InvalidCredential => e
            render text: 'invalid credential', status: :unauthorized
          end
        end
      end
    end
  end
end

ActionController::Base.send :include, Iftttify::ActAsIFTTT
