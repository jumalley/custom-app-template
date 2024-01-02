fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Custom App for qs-vehiclekeys'

author 'Ju'

client_script 'client.lua'

ui_page 'html/index.html'

files {
    'html/*'
}

escrow_ignore 'client.lua'

dependency '/assetpacks'

dependencies {
    'ox_lib',
    'qs-vehiclekeys'
}

shared_script '@ox_lib/init.lua'
