fx_version 'bodacious'
games { 'gta5' }

client_script {
	'client.lua'
}
server_script {
	'server.lua'
}

ui_page('html/index.html')

files({
	"html/*",
})

export 'setVoipMode'
export 'isTalkingWithoutRadio'
export 'isTalkingWithRadio'