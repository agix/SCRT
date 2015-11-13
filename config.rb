I18n.default_locale = :fr
activate :i18n

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir, 'fonts'

activate :dotenv

helpers do
  def svg_tag(svg, opts = {})
    content_tag :svg, opts do
      tag :use, 'xlink:href' => "##{svg}"
    end
  end

  def icon_tag(svg, opts = {})
    opts[:width] ||= 24
    opts[:height] ||= 24
    opts[:class] = [opts[:class], 'icon'].compact.join(' ')
    svg_tag("#{svg}-icon", opts)
  end

  def inline_svg(path)
    File.open "source/images/#{path}", 'rb', &:read
  end

  def markdown(key)
    engine = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
    engine.render I18n.t(key)
  end
end

configure :development do
  Slim::Engine.options[:pretty] = true
  activate :livereload, no_swf: true, apply_css_live: true
end

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash

  Slim::Engine.options[:pretty] = false

  # Use relative URLs
  activate :relative_assets

  activate :asset_host
  # set :asset_host, '//scrt.fr'

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :s3_sync do |s3_sync|
  s3_sync.bucket                = 'wip.calyh.re'
  s3_sync.region                = 'eu-west-1'
  s3_sync.aws_access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  s3_sync.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  s3_sync.acl                   = 'public-read'
  s3_sync.prefix                = 'scrt'
end
