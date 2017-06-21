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
        if content_for?(:proxytitle)
            yield_content(:proxytitle) + " | " + project_setting(:title)
        elsif current_page.data.title
            current_page.data.title + " | " + project_setting(:title)
        else
            project_setting(:title)
        end
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
    def get_product_url(product)
        "/products/#{product.category}/#{product.name.gsub(/\'/, "").parameterize}.html"
    end

    # return array of affiliate links for other scents/flavors 
    def get_other_varieties(product)
        variety = []
        data.products.each do |key, this|
            if product.manufacturer.eql?(this.manufacturer) && 
                    product.category.eql?(this.category) && 
                    product.type.eql?(this.type) &&
                    !product.id.equal?(this.id)
                variety.push(link_to(this.scent, this.affiliate_link))
            end
        end
        return variety
    end

    def get_post_url(article_title)
        blog.articles.find { |article| article.title.downcase == article_title.downcase }.url
        #rescue
        #""
    end

    def eval_str(str)
        eval "%Q[#{str}]"
    end

    def blog_img(img, alt)
        image_tag img, { alt: alt, class: "img-responsive" }
    end

    def slider_img(img_set)
        image_tag img_set[0], { alt: img_set[1] }
    end

    def setname(src, size)
        ext = File.extname(src)
        dir = File.dirname(src)
        name = File.basename(src, ext)
        "/assets/images/" + dir + "/sets/" + name + "-" + size + ext
    end

    def setexists?(src)
        sitemap.find_resource_by_path(setname(src, "1x"))
    end

    def pic_tag(src)
        tag = "<picture>"
        tag << %Q^\n\t<source srcset="#{setname(src, "3x")}" media="(min-width: 1200px)">^ 
        tag << %Q^\n\t<source srcset="#{setname(src, "2x")}" media="(min-width: 600px)">^
        tag << %Q^\n\t<img src="#{setname(src, "1x")}" alt="This picture loads on non-supporting browsers.">^
        tag << "\n</picture>"
    end
    
    def pic_tag2(src)
        tag = "<picture>"
        tag << %Q^\n\t<source srcset="#{setname(src, "3x")}" media="(min-width: 1200px)">^ 
        tag << %Q^\n\t<source srcset="#{setname(src, "2x")}" media="(min-width: 600px)">^
        tag << %Q^\n\t<img src="#{setname(src, "1x")}" alt="This picture loads on non-supporting browsers.">^
        tag << "\n</picture>"
    end

    def pic2(src)
        img_dir = "assets/images"
        src_ext = File.extname(src)
        src_dir = File.dirname(src)
        src_filebase = File.basename(src, src_ext)
        img_path = img_dir + "/" + src_dir + "/sets/" + src_filebase + "-large" + src_ext
        if sitemap.find_resource_by_path(img_path)
            x = 'file or directory exists' + img_path
        else
            x = 'could not find' + img_path
        end
        x
    end

    def pic(img_src)
        x = "
<picture> 
  <source srcset=\"/assets/images/AfricanBlackSoap/sets/#{img_src}-3x.jpg\" media=\"(min-width: 1200px)\" > 
  <source srcset=\"/assets/images/AfricanBlackSoap/sets/#{img_src}-2x.jpg\" media=\"(min-width: 600px)\" > 
  <img src=\"/assets/images/AfricanBlackSoap/sets/#{img_src}-1x.jpg\" alt=\"This picture loads on non-supporting browsers.\">
</picture>"
        x
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
