require "json"

file = Rails.root.join("db", "seeds", "scraped_products.json")
if File.exist?(file)
  items = JSON.parse(File.read(file))
  items.each do |i|
    category = Category.find_by(name: i["category_name"]) || Category.first
    Product.create!(
      name: i["name"],
      description: i["description"],
      base_price: i["base_price"],
      stock_quantity: i["stock_quantity"],
      product_type: i["product_type"],
      category: category,
      on_sale: i["on_sale"],
      featured: i["featured"]
    )
  end
  puts "Imported #{items.size} scraped products"
else
  puts "No scraped_products.json found"
end
