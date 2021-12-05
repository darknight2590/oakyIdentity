fx_version 'cerulean'
game 'gta5'

author 'oaky Development'

ui_page 'html/ui.html'

client_script 'client/main.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

dependency {
    'es_extended',
    'mysql-async'
}

files {
    'html/ui.html',
    'html/script.js',
    'html/style.css',
    'html/assets/*.png',
    'html/assets/fonts/*.otf',
    'html/assets/fonts/*.ttf'
}