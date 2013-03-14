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
    require 'goodreads'
    include Utils::Service
    # tag : inspirational
    # author : 947.William_Shakespeare
    # author_id : 947
    def initialize(opt={})
      if opt[:author]       
        @info = "/author/quotes/" + opt[:author]
      elsif opt[:tag]
        @info = "/quotes/tag/" + opt[:tag]
      else
        @info = "/quotes"
      end
      @url = ::Quote::BASE_URL + @info
      @count = ::Quote.count
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

        "#{::Quote.count - @count} new quotes"
      else
        "error: page not found"
      end
    end

    def get_author(name)
      key = load_service['goodreads']['app_key']
      secret = load_service['goodreads']['app_secret']
      client = Goodreads::Client.new(:api_key => key, :api_secret => secret)
      author = client.author_by_name(name)
      author.id
    end
  end
end