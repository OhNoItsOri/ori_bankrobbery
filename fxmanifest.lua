-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

author 'Ori'
description ''
version '0.1.0'

shared_scripts {
    '@ox_lib/init.lua',
}

client_script 'client/**.lua'

server_script 'server/**.lua'


files {
    'shared/config.lua',
}

lua54 'yes'
