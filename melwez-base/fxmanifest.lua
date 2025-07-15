fx_version 'bodacious'
games {'gta5'}
version '1.0.0'
lua54 'yes'
author 'Melwez'
description 'melwez-base'

shared_scripts { 
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}