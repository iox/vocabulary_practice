# Install gems "sinatra" and "tts"
# Install packages "dir2ogg" and "lame"


# myapp.rb
require 'sinatra'
require 'tts'
require 'json'
require 'rest-client'

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

get '/load_new_words' do
  # Cargar el token en memoria a partir de "babbel_auth_token.txt"
  auth_token = File.open('babbel_auth_token.txt', 'r').readlines[0].gsub("\n", "")

  # Leer y parsear el fichero de palabras actual para sacar los ids de las palabras
  words = JSON.parse(File.read("public/words.json"))

  # Enviar una peticion POST a https://api.babbel.com/v3/en_GB/learn_languages/DAN/trainer_items/states?auth_token=yxxvrNFXH_gkiQaMsfT3
  # Con el siguiente contenido
  # trainer_items_states: [{id: 3533159, difficulty: 3, mistakes: 2}, {id: 3533160, difficulty: 3, mistakes: 2},…]
  items = words["review"]["trainer_items"].map{|w|
    {
      id: w["id"],
      difficulty: w["knowledge_state"],
      mistakes: 0
    }
  }
  body = { :trainer_items_states => items }
  response = RestClient.put "https://api.babbel.com/v3/en_GB/learn_languages/DAN/trainer_items/states?auth_token=#{auth_token}", body.to_json , {:content_type => :json}


  # Descargar nuevas palabras
  new_words = RestClient.get("https://api.babbel.com/v3/en_GB/learn_languages/DAN/trainer_items/due?auth_token=#{auth_token}").to_str
  File.write("public/words.json", new_words)

  # Redirigir a /
  redirect to '/'
end
