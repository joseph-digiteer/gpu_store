# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# Helper method to create products and variants
def create_product_with_variants(product_name, series, variants)
  product = Product.find_or_create_by!(name: product_name) do |p|
    p.description = "#{series} Series #{product_name}"
    p.active = true
  end

  variants.each do |variant|
    ProductVariant.create!( product: product, name: variant[:name], description: variant[:description], price: variant[:price_php], stock: variant[:stock], active: true, series: series )
  end
end

# Product variants data for different series
product_variants_data = [
  # NVIDIA 40 Series
  { product: 'RTX 4090', series: '40 Series', name: 'RTX 4090', description: 'High-end 4K gaming performance.', price_php: 159999.99, stock: 20 },
  { product: 'RTX 4080', series: '40 Series', name: 'RTX 4080', description: 'Excellent 1440p and 4K gaming.', price_php: 129999.99, stock: 15 },
  { product: 'RTX 4070 Ti', series: '40 Series', name: 'RTX 4070 Ti', description: 'Great for 1440p and high refresh rates.', price_php: 99999.99, stock: 10 },
  { product: 'RTX 4070', series: '40 Series', name: 'RTX 4070', description: 'High-performance for 1440p gaming.', price_php: 84999.99, stock: 10 },
  { product: 'RTX 4060 Ti', series: '40 Series', name: 'RTX 4060 Ti', description: 'Great performance for 1080p gaming.', price_php: 69999.99, stock: 12 },
  { product: 'RTX 4060', series: '40 Series', name: 'RTX 4060', description: 'Affordable option for 1080p gaming.', price_php: 54999.99, stock: 8 },
  { product: 'RTX 4050 Ti', series: '40 Series', name: 'RTX 4050 Ti', description: 'Entry-level 1080p gaming performance.', price_php: 49999.99, stock: 15 },
  { product: 'RTX 4050', series: '40 Series', name: 'RTX 4050', description: 'Budget-friendly option for 1080p gaming.', price_php: 39999.99, stock: 10 },
  { product: 'RTX 4080 Founders Edition', series: '40 Series', name: 'RTX 4080 Founders Edition', description: 'Premium edition with enhanced cooling.', price_php: 139999.99, stock: 5 },
  { product: 'RTX 4090 Founders Edition', series: '40 Series', name: 'RTX 4090 Founders Edition', description: 'Top-of-the-line graphics card with best performance.', price_php: 169999.99, stock: 3 },
  
  # NVIDIA 30 Series
  { product: 'RTX 3090', series: '30 Series', name: 'RTX 3090', description: 'Top-tier graphics card for professionals.', price_php: 129999.99, stock: 15 },
  { product: 'RTX 3080', series: '30 Series', name: 'RTX 3080', description: 'High performance for 4K gaming.', price_php: 99999.99, stock: 20 },
  { product: 'RTX 3070', series: '30 Series', name: 'RTX 3070', description: 'Great performance for 1440p gaming.', price_php: 74999.99, stock: 15 },
  { product: 'RTX 3060 Ti', series: '30 Series', name: 'RTX 3060 Ti', description: 'Excellent value for high refresh rate gaming.', price_php: 54999.99, stock: 10 },
  { product: 'RTX 3060', series: '30 Series', name: 'RTX 3060', description: 'Affordable option for 1080p gaming.', price_php: 44999.99, stock: 12 },
  { product: 'RTX 3050 Ti', series: '30 Series', name: 'RTX 3050 Ti', description: 'Entry-level gaming card for 1080p.', price_php: 34999.99, stock: 18 },
  { product: 'RTX 3050', series: '30 Series', name: 'RTX 3050', description: 'Budget-friendly option for casual gaming.', price_php: 29999.99, stock: 20 },
  { product: 'RTX 3080 Founders Edition', series: '30 Series', name: 'RTX 3080 Founders Edition', description: 'Premium edition with enhanced cooling.', price_php: 104999.99, stock: 7 },
  { product: 'RTX 3090 Founders Edition', series: '30 Series', name: 'RTX 3090 Founders Edition', description: 'Highest performance in the 30 Series.', price_php: 134999.99, stock: 5 },
  { product: 'RTX 3070 Ti', series: '30 Series', name: 'RTX 3070 Ti', description: 'Enhanced performance compared to the 3070.', price_php: 79999.99, stock: 10 },

  # AMD 6000 Series
  { product: 'RX 6900 XT', series: '6000 Series', name: 'RX 6900 XT', description: 'High-end performance for 4K gaming.', price_php: 37999.99, stock: 15 },
  { product: 'RX 6800 XT', series: '6000 Series', name: 'RX 6800 XT', description: 'Excellent for 1440p and 4K gaming.', price_php: 29999.99, stock: 20 },
  { product: 'RX 6700 XT', series: '6000 Series', name: 'RX 6700 XT', description: 'Great for 1440p gaming.', price_php: 23999.99, stock: 15 },
  { product: 'RX 6600 XT', series: '6000 Series', name: 'RX 6600 XT', description: 'Good performance for 1080p gaming.', price_php: 18999.99, stock: 10 },
  { product: 'RX 6800', series: '6000 Series', name: 'RX 6800', description: 'High-performance card for 1440p and 4K.', price_php: 25999.99, stock: 12 },
  { product: 'RX 6700', series: '6000 Series', name: 'RX 6700', description: 'Affordable option for high refresh rate 1440p.', price_php: 21999.99, stock: 15 },
  { product: 'RX 6600', series: '6000 Series', name: 'RX 6600', description: 'Budget-friendly option for 1080p.', price_php: 17999.99, stock: 18 },
  { product: 'RX 6900 XT Liquid Cooled', series: '6000 Series', name: 'RX 6900 XT Liquid Cooled', description: 'High-end card with liquid cooling for extreme performance.', price_php: 40999.99, stock: 8 },
  { product: 'RX 6700 XT Pulse', series: '6000 Series', name: 'RX 6700 XT Pulse', description: 'Enhanced cooling and performance.', price_php: 24999.99, stock: 10 },
  { product: 'RX 6600 XT Pulse', series: '6000 Series', name: 'RX 6600 XT Pulse', description: 'Great performance with enhanced cooling.', price_php: 19999.99, stock: 12 },
]

# Create products and their variants
product_variants_data.each do |variant_data|
  create_product_with_variants(variant_data[:product], variant_data[:series], [variant_data])
end
