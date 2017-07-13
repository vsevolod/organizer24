# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w[kedavra sadmin].map{|theme| "themes/#{theme}.js"}
Rails.application.config.assets.precompile += %w[default embark beauty kedavra sadmin].map{|theme| "themes/#{theme}.css"}
Rails.application.config.assets.precompile += %w[
  ckeditor/filebrowser/images/gal_del.png
  ckeditor/skins/kama/editor.css
  ckeditor/lang/ru.js
  ckeditor/plugins/embed/plugin.js
  ckeditor/plugins/attachment/plugin.js
  ckeditor/config.js
  ckeditor/plugins/embed/lang/ru.js
  ckeditor/plugins/attachment/lang/ru.js
  ckeditor/contents.css
  ckeditor/plugins/styles/styles/default.js
]
Rails.application.config.assets.precompile += %w[
  company.css
  fullcalendar.print.css
  fc.js
  month_calendar.js
  calendar.js
  photo.js
  jquery.fileupload-ui.css
  themes/edge/font-awesome.css
  themes/edge/theme.css
  themes/edge/font-awesome-ie7.css
]
