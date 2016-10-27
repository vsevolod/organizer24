# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(ckeditor/skins/kama/editor.css ckeditor/lang/ru.js ckeditor/plugins/embed/plugin.js ckeditor/plugins/attachment/plugin.js ckeditor/config.js  ckeditor/plugins/embed/lang/ru.js ckeditor/plugins/attachment/lang/ru.js ckeditor/contents.css ckeditor/plugins/styles/styles/default.js)
Rails.application.config.assets.precompile += %w(fullcalendar.print.css fc.js month_calendar.js calendar.js themes/embark.css themes/beauty.css photo.js jquery.fileupload-ui.css company.css  themes/default.css themes/edge/font-awesome.css themes/edge/theme.css themes/edge/font-awesome-ie7.css themes/sadmin.css themes/sadmin.js)
