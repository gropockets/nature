module SiteHelpers

  # Used to check if a link goes to the current page by passing in a nav and
  # subnav string to check against the frontmatter within data.page.
  def current?(nav, subnav = "")
    if subnav.empty?
      nav == current_page.data.nav
    else
      nav == current_page.data.nav && subnav == current_page.data.subnav
    end
  end

  def page_title
    (current_page.data.title.blank? ? '' : "#{current_page.data.title} - ") + project_setting(:title)
  end

  # Creates a description meta tag based on the presence of a description value within the page frontmatter.
  def page_description
    content_tag :meta, "", {name: "description", value: current_page.data.description } if current_page.data.description
  end

  # Generates character length lorem ipsum strings
  def greek(chars)
    Lorem::Base.new('chars', chars).output
  end

  # Creates a link only if the condition returns true, otherwise returns only the element.
  def link_to_if(condition, element, link)
    if condition
      link_to(element, link)
    else
      element
    end
  end

  # Calls appropriate key in /data/config.yml depending on current environment.
  def project_setting(key)
    data.config[config[:environment]][key]
  end

  # create url from product name (e.g. tom's soap => toms-soap)
  def get_product_url(type, product)
    "/products/#{type}/#{product['name'].gsub(/\'/, "").parameterize}.html"
  end

  #require 'net/smtp'
  
  # Send prototyped transactional emails.
  #def send_mail(template, opts={})
    #if development?
      #begin
        #to      = opts[:to] || project_setting(:mail_to)
        #from    = project_setting(:mail_from)
        #subject = opts[:subject] || "(No Subject)"
        #content = File.read(File.join(root, "mailers", "#{template}.html"))
        #host    = project_setting(:mail_host)
        #port    = project_setting(:mail_port)
        #message = build_message(to, from, subject, content)

        ## If you need to customize this further you can use the following into the start method
        ## (host, port, domain, username, password :plain)
        #Net::SMTP.start(host, port) do |smtp|
          #smtp.sendmail(message, from, [to])
        #end
      #rescue
        #false
      #end
    #else
      #true
    #end
  #end

  #private

  ## Returns a string to send as the mail message
  #def build_message(to, from, subject, body)
    #"From: #{from}\nTo: #{to}\nContent-type: text/html\nSubject: #{subject}\n\n#{body}"
  #end

end
