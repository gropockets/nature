###
# Page options, layouts, aliases and proxies
###
#
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration
set :slim, { pretty: true }

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"
  blog.layout = "article_layout"
  blog.tag_template = "tag.html"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"
  #blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

# Build-specific configuration
configure :build do
  set :http_prefix, '/demo/nature/build/'

  # deprecated grid of products by category/tag
  ignore "/products/template.html.erb"
  ignore "/products/index.html.erb"
  ignore "**/*.swp"

  # testing directory
  ignore "/test/*"
  
  #activate :minify_css
  #activate :minify_javascript
end

# create url from product name (e.g. tom's soap => toms-soap); identical to helper function in sitehelpers
def get_product_url(product)
  "/products/#{product.category}/#{product.name.gsub(/\'/, "").parameterize}.html"
end

# Proxy pages for individual products (without "published" attribute set to false)
data.products.each do |p, info|
  if (!defined? info.published) || (info.published)
    proxy get_product_url(info), "/products/detail_template.html", :locals => { :product => info }, :ignore => true
  end
end

# ** Commented out after restructuring data file; Need helper function to get all items in each category ** 
# Proxy pages for products and categories


