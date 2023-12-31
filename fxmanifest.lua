fx_version 'cerulean'

game 'gta5'

lua54 'yes'

client_script {
    'client.lua'
}

ui_page {
    'html/index.html'
}

files({
    'html/*'
})

escrow_ignore {
    'client.lua'
}

dependency '/assetpacks'