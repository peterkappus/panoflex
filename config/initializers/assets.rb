# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

#shouldn't have to do this for govuk_template...but I did.
Rails.application.config.assets.precompile += %w(
        favicon.ico
        govuk-template*.css
        fonts*.css
        govuk-template.js
        ie.js
        vendor/goog/webfont-debug.js
        apple-touch-icon-120x120.png
        apple-touch-icon-144x144.png
        apple-touch-icon-114x114.png
        apple-touch-icon-152x152.png
        gov.uk_logotype_crown.png
        apple-touch-icon-72x72.png
        apple-touch-icon-60x60.png
        apple-touch-icon-57x57.png
        apple-touch-icon-76x76.png
        gov.uk_logotype_crown_invert.png
        gov.uk_logotype_crown_invert_trans.png
        opengraph-image.png
        icons/icon-pointer.png
        icon-pointer.png
      )
