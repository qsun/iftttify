[![Build Status](https://travis-ci.org/qsun/iftttify.svg?branch=master)](https://travis-ci.org/qsun/iftttify)


# iftttify

IFTTTify your Rails app, enables IFTTT to talk to our Rails apps using Wordpress XMLRPC protocol.

## Usage

1. Modify `routes.rb`

```ruby
post 'xmlrpc.php' => 'pages#ifttt_action'
```

2. In your controller, add

```ruby
iftttify :ifttt_action, with: :process_post

private
def process_post(post)
    puts post
    42 # This is sort of important, it would be the post ID
end
```


3. (optional) authentication


```ruby
iftttify :ifttt_action, auth: {username: "username", password: "password"}, with: :process_post
```
