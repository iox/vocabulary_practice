# Install gems "sinatra" and "tts"
# Install packages "dir2ogg" and "lame"


# myapp.rb
require 'sinatra'
require 'tts'

set :port, 3000
set :bind, '0.0.0.0'

get '/' do
  send_file "public/index.html"
end

get '/say_ogg/:text' do
  params[:text].to_file "da", "temp.mp3"
  `dir2ogg temp.mp3 --mp3-decoder=lame`
  send_file "temp.ogg"
end

get '/say_mp3/:text' do
  params[:text].to_file "da", "temp.mp3"
  send_file "temp.mp3"
end

