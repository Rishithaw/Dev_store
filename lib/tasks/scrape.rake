namespace :scrape do
  desc "Scrape test site and create db/seeds/scraped_products.json"
  task testsite: :environment do
    require_relative "../../lib/scrapers/webscraper_testsite"
    scraper = Scrapers::WebscraperTestsite.new
    items = scraper.scrape_laptops

    out_dir = Rails.root.join("db", "seeds")
    FileUtils.mkdir_p(out_dir)
    out_file = out_dir.join("scraped_products.json")

    File.write(out_file, JSON.pretty_generate(items))
    puts "Wrote #{items.size} items to #{out_file}"
  end
end
