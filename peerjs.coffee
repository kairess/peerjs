if Meteor.isClient
	if Meteor.userId()
		peer = new Peer Meteor.userId(), {key: '7v3pa8gnzqmjwcdi'}
		console.log peer.connections

		peer.on 'open', ->
			console.log 'My peer ID is: ' + peer.id

		peer.on 'connection', (conn) ->
			conn.on 'data', (data) ->
				a = document.createElement "a"
				document.body.appendChild a
				a.style = "display: none"

				console.log data
				# myBlob = new Blob data, {type : 'image/jpeg'}
				# url = (window.URL || window.webkitURL).createObjectURL myBlob
				# a.href = url
				# a.download = '233232.jpg'
				# a.click()
				# (window.URL || window.webkitURL).revokeObjectURL url

	Template.userList.helpers
		users: ->
			users = Meteor.users.find()
			return users
		isOther: (userId) ->
			return Meteor.userId() != userId

	Template.userList.events
		"click button": (event, template) ->
			userId = $(event.currentTarget).attr "userId"

			input = template.find('#input-box').files[0]

			reader = new FileReader()

			reader.readAsBinaryString input

			reader.onprogress = (event) ->
			if event.lengthComputable
				# progressNode.max = event.total;
				# progressNode.value = event.loaded;
				console.log event

			reader.onloadend = (event) ->
				contents = event.target.result
				error = event.target.error

				if error != null
					console.error "File could not be read! Code " + error.code
				else
					# progressNode.max = 1;
					# progressNode.value = 1;
					# console.log "Contents: " + contents

					conn = peer.connect userId
					conn.on 'open', ->
						conn.send contents
						# template.find('#input-box').value = ''

	Accounts.ui.config
		passwordSignupFields: 'USERNAME_ONLY'

if Meteor.isServer
	Meteor.methods
		"sendMessage": (file) ->
			console.log file
			# conn = Session.get "conn"
			#
			# send = Meteor.npmRequire('peer-file/send')
			#
			# send(conn, file).on 'progress', (bytesSent) ->
			# 	Math.ceil bytesSent / file.size * 100
