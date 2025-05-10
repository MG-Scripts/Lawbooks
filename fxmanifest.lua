fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'MDT-Lawbooks'
author 'MG-Scripts'
description 'Show Lawbooks from myEmergency MDT'
version '1.0.0'

ui_page 'ui/index.html'

shared_scripts {
    "@oxmysql/lib/MySQL.lua",
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

files {
    'ui/index.html',
    'ui/assets/css/styles.css',
    'ui/assets/js/base.js',
    'ui/assets/js/jquery.min.js',
    'ui/assets/bootstrap/js/*.js',
    'ui/assets/bootstrap/js/*.js.*',
    'ui/assets/bootstrap/css/*.css',
    'ui/assets/bootstrap/css/*.css.*',
}

dependencies {
    'oxmysql',
    'myEmergency'
}

