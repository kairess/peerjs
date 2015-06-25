if Meteor.isClient
	peer = new Peer Meteor.userId(), {key: '7v3pa8gnzqmjwcdi'}
	peer.on 'open', ->
		console.log 'My peer ID is: ' + peer.id

	peer.on 'connection', (conn) ->
		conn.on 'data', (data) ->
			console.log(data)

	Template.userList.helpers
		users: ->
			users = Meteor.users.find()
			return users

	Template.userList.events
		"click button": (event, template) ->
			userId = $(event.currentTarget).attr "userId"

			conn = peer.connect userId
			conn.on 'open', ->
				conn.send('hi!')

	Accounts.ui.config
		passwordSignupFields: 'USERNAME_ONLY'
