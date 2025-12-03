# lib/scrapers/webscraper_testsite.rb
require "httparty"
require "nokogiri"
require "json"

module Scrapers
  class WebscraperTestsite
    BASE = "https://webscraper.io/test-sites/e-commerce/allinone"

    def initialize
      @items = []
    end

    def scrape_laptops
      url = "#{BASE}/computers/laptops"
      doc = fetch_doc(url)

      doc.css(".thumbnail").each do |thumb|
        name_el = thumb.at_css(".title")
        next unless name_el

        name = name_el["title"] || name_el.text.strip
        description = (thumb.at_css(".description")&.text || "").strip
        price_text = (thumb.at_css(".price")&.text || "").gsub(/[^\d\.]/, "")
        base_price = price_text.present? ? price_text.to_f : 0.0
        category_name = "Laptops"

        @items << {
          name: name,
          description: description,
          base_price: base_price,
          stock_quantity: rand(10..150),
          product_type: "physical",
          category_name: category_name,
          on_sale: false,
          featured: false
        }
      end

      @items
    end

    private

    def fetch_doc(url)
      resp = HTTParty.get(url, headers: { "User-Agent" => "RWDevStoreScraper/1.0 (+dev contact)" })
      raise "Failed to fetch #{url}: #{resp.code}" unless resp.code == 200

      Nokogiri::HTML(resp.body)
    end
  end
end
