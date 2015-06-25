if Meteor.isClient
	peer = new Peer Meteor.userId(), {key: '7v3pa8gnzqmjwcdi'}
	peer.on 'open', ->
		console.log 'My peer ID is: ' + peer.id

	peer.on 'connection', (conn) ->
		conn.on 'data', (data) ->
			console.log(data)

	Template.hello.events
		"click button": (event, template) ->
			conn = peer.connect('bAXCe8EHJk5ygXq6t')
			conn.on 'open', ->
				conn.send('hi!')
			console.log 'button clicked!'
