urls = ['./words.json']
items = []
current_index = 0
root = exports ? this
audioElement = document.createElement("audio")


$ ->
  for url in urls
    $.getJSON url, ( data ) ->
      Array::push.apply items, data["review"]["trainer_items"]
      load_item()


root.load_next_item = ->
  if $('#danish').html() == '&nbsp;'
    $('#danish').html(items[current_index]['l2_text'])
  else
    current_index += 1
    if current_index >= items.length
      current_index = 0
    load_item()

root.load_item = ->
  $('#danish').html('&nbsp;')
  $('#english').html(items[current_index]['l1_text'])
  $('#counter').html("#{current_index + 1} / #{items.length}")

root.play = ->
  if $('#danish').html() == '&nbsp;'
    $('#danish').html(items[current_index]['l2_text'])

  text = items[current_index]['l2_text']

  if (audioElement.canPlayType('audio/mpeg;'))
    audioElement.setAttribute "src", "/say_mp3/#{text}"
  else
    audioElement.setAttribute "src", "/say_ogg/#{text}"
  audioElement.play()
  #audioElement.setAttribute "autoplay", "autoplay"

  $.get()
  audioElement.addEventListener "load", ->
    audioElement.play()
