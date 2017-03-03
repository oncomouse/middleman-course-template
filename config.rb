###
# Compass
###

set :markdown_engine, :kramdown
set :markdown, :fenced_code_blocks => true,
			   :autolink => true, 
			   :smartypants => true,
			   :footnotes => true,
			   :superscript => true

# Change Compass configuration
compass_config do |config|
#	 config.output_style = :compact
end

###
# Variables
###

activate :sprockets

# Figure out the course's file name to set deploy path
@course_tag = File.basename Dir.pwd

# Base path for all courses:
config[:build_http_prefix] = "/courses/#{@course_tag}"

# Shared javascript prefix (set this to the base URL of your shared JS repository, if using):
config[:shared_javascript_prefix] = ''

###
# Page options, layouts, aliases and proxies
###

page "*", :layout => "layout"

if config[:shared_javascript_prefix] != "" and config[:shared_javascript_prefix] =~ /[^\/]$/
	config[:shared_javascript_prefix] = "#{config[:shared_javascript_prefix]}/"
end

ready do
	proxy "/#{@course_tag}.yml", "/course.yml" if "/#{@course_tag}.yml" != "/course.yml"
	ignore "/course.yml" if "/#{@course_tag}.yml" != "/course.yml"
	ignore "**/*.rb"
end

after_configuration do
	@bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
	sprockets.append_path File.join "#{root}", @bower_config["directory"]
	compass_config do |config|
			config.add_import_path File.join "#{root}", @bower_config["directory"]
	end
end

set :haml, { :ugly => false, :format => :html5 }

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

###
# Build-specific configuration
###

configure :build do
    
    # Ignore files that get built into shared assets by sprockets (see app.js and app.css.scss):
	ignore 'javascripts/site.js'
	ignore 'javascripts/bootstrap.js'
	ignore 'vendor/**/*'
	
	if config[:shared_javascript_prefix] != ""
		ignore 'javascripts/app.js'
        ignore 'javascripts/css3-mediaqueries.js'
	end
	
	set :http_prefix, config[:build_http_prefix]

	activate :minify_css
	activate :minify_javascript
	#activate :gzip
	activate :cache_buster
end

###
# Deployment
###
activate :deploy do |deploy|
	deploy.deploy_method = :rsync
	deploy.user = "some_user"
	deploy.host = "some_server"
	deploy.path = "~/www#{config[:build_http_prefix]}"
end