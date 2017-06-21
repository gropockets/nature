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

    def pic_tag(src, options)
        if setexists?(src)
            tag = "<picture>"
            tag << %Q^\n\t^ + tag(:source, :srcset => setname(src, "3x"), :media => "(min-width: 1200px)") 
            tag << %Q^\n\t^ + tag(:source, :srcset => setname(src, "2x"), :media => "(min-width: 600px)") 
            tag << %Q^\n\t^ + image_tag(setname(src, "1x"), options)
            tag << "\n</picture>"
        else
            image_tag src, options
        end
    end
    
end
