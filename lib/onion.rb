# coding: utf-8 
module Onion
  # 查单词
  class FetchWord  
    def initialize(word)
      url = $dict_source[:english]+word
      page = Mechanize.new.get(url)
      target = page.parser.xpath("//div[@class='simple_content']")
      @word = word
      @comment = target.text.gsub("\r\n","").strip      
    end
  
    def insert    
      if !@comment.blank?
        Word.create(:title => @word,:content => @comment)
      end    
    end   
  end
  
  class Quote
    include Utils::Service
    # tag : inspirational
    # author : 947.William_Shakespeare
    # author_id : 947
    def initialize(opt={})
      @base_url = "http://www.goodreads.com"
      if opt[:author_id]
        @url = @base_url + "/author/quotes/" + spell_author(opt[:author_id])
      elsif opt[:author]
        @url = @base_url + "/author/quotes/" + opt[:author]
      elsif opt[:tag]
        @url = @base_url + "/quotes/tag/" + opt[:tag]
      else
        @url = @base_url + "/quotes"
      end
    end
    
    def fetch
      frame = Nokogiri::HTML(open(@url),nil)
      if frame
        frame.css(".quoteDetails").each do |x| 
          quote = ::Quote.new
          _text = x.css(".quoteText")[0]
          unless _text.css("i a").blank? 
            source_name = _text.css("i a")[0].text 
            source_link = _text.css("i a")[0]["href"]
            quote.source = {:name => source_name,:link => source_link}
          end      
          author_name = _text.css("a")[0].text
          author_link = _text.css("a")[0]["href"]
          quote.author = {:name => author_name,:link => author_link}
          quote.content = _text.text.scan(/ “.+”/)[0]#scan(/&ldquo;.+&rdquo;/)

          _foot = x.css(".quoteFooter .left")[0]
          if _foot
            tags = _foot.css("a").inject([]) do |a,e|
              a << e.text
            end
          end
          quote.tags = tags
          quote.save
        end
      end
    end

    def get_author(name)
      key = load_service['goodreads']['app_key']
      secret = load_service['goodreads']['app_secret']
      client = Goodreads::Client.new(:api_key => key, :api_secret => secret)
      author = client.author_by_name(name)
    end
    
    private

    def spell_author(id)
      name = YAML.load_file(Rails.root.join("doc", "goodreads.yml")).fetch("author")[id]
      "#{id}.#{name}"
    end
  end
end