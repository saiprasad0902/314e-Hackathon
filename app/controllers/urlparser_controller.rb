require 'uri'
require 'nokogiri'
require 'open-uri'
class UrlparserController < ApplicationController
  def index
    @data = ""
    @pages = []
    flash.alert = ""
    @url = params[:url]
    if @url.nil? || @url == ""
      flash.alert = "URL cant be empty"
    elsif !(@url.nil? || @url == "") && (!valid_url?(@url))
      flash.alert = "URL invalid"
    else
      parser = UrlparserHelper::Parser.new
      parser.fetch_all(@url)
      @pages.push(Page.new(frequent_words: parser.instance_variable_get(:@frequent_words),
                           frequent_word_pairs: parser.instance_variable_get(:@frequent_word_pairs),
                           links: parser.instance_variable_get(:@hrefs),
                           url: @url))
      primary_links = @pages[0].instance_variable_get(:@links)
      primary_links.each_with_index do |(key, value), index|
        if index > 4
          break
        end
        parser.fetch_all(value)
        @pages.push(Page.new(frequent_words: parser.instance_variable_get(:@frequent_words),
                             frequent_word_pairs: parser.instance_variable_get(:@frequent_word_pairs),
                             links: parser.instance_variable_get(:@hrefs),
                             url: value))
      end
      @pages
    end
  end

  def show
  end

  # Only allow a list of trusted parameters through.
  def urlparser_params
    params.fetch(:url, {})
  end

  private

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end

class Page
  attr_accessor :frequent_words, :frequent_word_pairs, :links, :url
  def initialize(frequent_words:, frequent_word_pairs:, links:, url:)
    @frequent_words = frequent_words
    @frequent_word_pairs = frequent_word_pairs
    @links = links
    @url = url
  end
end