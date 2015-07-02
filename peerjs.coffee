dataURItoBlob = (dataURI) ->
	byteString;
	if dataURI.split(',')[0].indexOf('base64') >= 0
		byteString = atob dataURI.split(',')[1]
	else
		byteString = unescape dataURI.split(',')[1]
	mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
	ia = new Uint8Array byteString.length
	i = 0
	while i < byteString.length
		ia[i] = byteString.charCodeAt i
		i++

	return new Blob [ia], {encoding:"UTF-8", type:mimeString}

if Meteor.isClient
	if Meteor.userId()
		peer = new Peer Meteor.userId(), {key: '7v3pa8gnzqmjwcdi'}

		peer.on 'open', ->
			console.log 'My peer ID is: ' + peer.id

		peer.on 'connection', (conn) ->
			conn.on 'data', (data) ->
				a = document.createElement "a"
				document.body.appendChild a
				a.style = "display: none"
				blobData = dataURItoBlob data.contents

				url = (window.URL || window.webkitURL).createObjectURL blobData
				a.href = url
				a.download = data.filename
				a.click()
				(window.URL || window.webkitURL).revokeObjectURL url

		peer.on 'error', (err) ->
			console.log 'error!' ,err

		peer.on 'close', ->
			console.log 'closed!'

		peer.on 'disconnected', ->
			console.log 'disconnected'
			peer.reconnect()

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

			reader.readAsDataURL input

			# reader.onprogress = (event) ->
			# if event.lengthComputable
			# 	console.log event

			reader.onloadend = (event) ->
				contents = event.target.result
				error = event.target.error

				if error != null
					console.error "File could not be read! Code " + error.code
				else
					conn = peer.connect userId

					conn.on 'open', ->
						conn.send {
							filename: input.name
							contents: contents
						}
						# template.find('#input-box').value = ''

	Accounts.ui.config
		passwordSignupFields: 'USERNAME_ONLY'
