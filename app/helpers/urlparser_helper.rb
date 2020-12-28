require 'uri'
require 'nokogiri'
require 'open-uri'
module UrlparserHelper
  class Parser
    def fetch_all(host)
      @host = host
      @document = ""
      @tags = Hash.new
      @frequent_words = Hash.new
      @frequent_word_pairs = Hash.new
      @links = Hash.new
      @hrefs = Hash.new
      @page_text_data = ""
      fetch(@host)
    end
    def fetch(url)
      @document = Nokogiri::HTML.parse(open(url))
      fetch_tags
    end

    def fetch_tags
      tags = Hash.new(0)
      @document.traverse do |node|
        next unless node.is_a?(Nokogiri::XML::Element)
        tags[node.name] += 1
      end
      # contains all the HTML tags available in the parsed document
      @tags = tags
      get_all_hrefs
    end

    def get_all_hrefs
      all_herefs = Hash.new
      @document.xpath('//a[@href]').each do |link|
        all_herefs[link.text.strip] = link['href']
      end
      # Getting all the hrefs from the doc
      # this will contain external and invalid links , we have to clean them next
      clean_hrefs(all_herefs)
    end

    def clean_hrefs(all_herefs)
      # removing blank URLS
      all_herefs.delete_if { |key, value| value.to_s.strip == '#' }
      #getting the current host
      address = URI.parse(@host).host
      # removing the hrefs if the host is not current parent.
      @hrefs =  all_herefs.reject{|k,v| !v.match(address)}
      get_text_from_html_doc
    end

    def get_text_from_html_doc
      text = ""
      valid_text_tags = Array['p','span','br','h1','h2','h3','h4','h5','h6','strong','em','q','hr','code','li','dt','dd',
                         'mark','ins', 'del','sup','sub','small','i','b']
      valid_text_tags.each do |tag|
        if @tags.has_key?(tag)
          text +=  @document.search(tag).text
        end
      end
      @page_text_data = text
      get_frequent_words
    end

    def get_frequent_words
      highest_wf_count = 0
      frequent_word = Hash.new
      max_word_count = 10
      word_count = Hash.new(0) # hash
      @page_text_data.split.each do |word|
        word_count[word.downcase] += 1
      end
      highest_wf_count = word_count.values.max
      while max_word_count != 0
          highest_wf_words = word_count.select { |key, value| value == highest_wf_count }
        if !highest_wf_words.empty? && check_for_a_special_charachter(highest_wf_words.keys[0])
          frequent_word.store(highest_wf_words.keys[0],highest_wf_count)
          highest_wf_count = highest_wf_count - 1
          max_word_count = max_word_count - 1
        else
          if !highest_wf_count.nil? && highest_wf_count >= 1
            highest_wf_count = highest_wf_count - 1
          else
            break
          end
        end
      end
      @frequent_words = frequent_word
      get_frequent_pair_words
    end

    def get_frequent_pair_words
      frequent_pair_word = Hash.new
      max_pair_word_count = 0
      pair_words = Hash.new
      a_text_data  = @page_text_data.split
      a_text_data.each_with_index do |text , index|
        if index+1 < a_text_data.size
          base_first = text
          base_second = a_text_data[index+1]
          (index + 1...a_text_data.size).each_with_index  do |n_text, counter|
             if(base_first.eql?(a_text_data[counter]) && base_second.eql?(a_text_data[counter+1]))
                if frequent_pair_word.has_key?(a_text_data[counter] + " " + a_text_data[counter+1])
                  value = frequent_pair_word[a_text_data[counter] + " " + a_text_data[counter+1]]
                  value = value + 1
                  frequent_pair_word[a_text_data[counter] + " " + a_text_data[counter+1]] = value
                  break
                else
                  frequent_pair_word.store(a_text_data[counter] + " " + a_text_data[counter+1],1)
                  break
                end
             end
          end
        end
      end
      ten_p_words = Hash.new
      pair_words = Hash[frequent_pair_word.sort_by { |k,v| [-1 * v] }]
      pair_words.each do | key, value |
        break if max_pair_word_count == 10
        ten_p_words.store(key,value)
        max_pair_word_count = max_pair_word_count + 1
      end
      @frequent_word_pairs = ten_p_words
    end

    def check_for_a_special_charachter(string)
      special = "?<>',?[]}{=-)(*&^%$#`~{}"
      regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
      if (string =~ regex).nil?
        true
      else
        false
      end
    end
  end
end
