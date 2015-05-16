url = './words.json'
items = []
current_index = 0
root = exports ? this
audioElement = document.createElement("audio")


$ ->
  $.getJSON url, ( data ) ->
    items = data["review"]["trainer_items"]
    console.log('about to call load_next_item')
    load_item()

    for item in data["review"]["trainer_items"]
      console.log(item)


root.load_next_item = ->
  if $('#danish').html() == '&nbsp;'
    $('#danish').html(items[current_index]['l2_text'])
    $('#play-button').show()
  else
    current_index += 1
    if current_index >= items.length
      current_index = 0
    load_item()

root.load_item = ->
  $('#danish').html('&nbsp;')
  $('#play-button').hide()
  $('#english').html(items[current_index]['l1_text'])
  $('#counter').html("#{current_index + 1} / #{items.length}")

root.play = ->
  text = items[current_index]['l2_text']

  audioElement.setAttribute "src", "/say/#{text}"
  audioElement.setAttribute "autoplay", "autoplay"

  $.get()
  audioElement.addEventListener "load", ->
    audioElement.play()
