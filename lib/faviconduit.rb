
require 'nokogiri'
require 'open-uri'
require "addressable/uri"


module Faviconduit

  class Error < StandardError; end
  class InvalidFavicon < Error; end
  class MissingFavicon < Error; end

  def self.read(url)

    uri = Addressable::URI.heuristic_parse(url)

    doc = Nokogiri::HTML(open(uri))

    path = doc.xpath("//link[@rel='shortcut icon' or @rel='icon']/@href").first
    path = path ? path.to_s : '/favicon.ico'

    fav_uri = Addressable::URI.join(uri, path.to_s)

    begin

      stream = open(fav_uri)

      unless stream.content_type[/^image/]
        raise(InvalidFavicon, "wrong content_type (#{stream.content_type})")
      end

      data = stream.read

      if data.size == 0
        raise(InvalidFavicon, "zero data")
      end

      return data

    rescue OpenURI::HTTPError => e
      raise MissingFavicon if e.to_s[/404/]
      raise # nevermind, reraise the previous exception
    end

  end

end
