# myapp.rb
require 'sinatra'
require 'tts'

set :port, 3000
set :bind, '0.0.0.0'

get '/' do
  send_file "public/index.html"
end

get '/say/:text' do
  params[:text].to_file "da", "temp.mp3"
  send_file "temp.mp3"
end
