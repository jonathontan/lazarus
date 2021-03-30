require 'rails_helper'

RSpec.describe 'Products', type: :request do

  let(:brand) { create(:brand) }

  let(:product_params) do
    attributes_for(:product) do |pd|
      pd[:brand_id] = brand.id
    end
  end

  describe '#index' do
    let!(:product_brand) { create(:product, brand: brand) }
    it 'list all Products' do
      get '/products'

      expect(response).to have_http_status(200)
      expect(response.body).to include('Test product 1')
    end
  end

  describe '#create' do
    it 'creates a Product and redirects to the show page' do
      post '/products', params: { product: product_params }

      expect(response).to redirect_to product_path(brand.products.last.id)
      follow_redirect!
      expect(response.body).to include('Test product 2')
    end
  end

  describe '#update' do
    let(:product_brand) { create(:product, brand: brand) }
    it 'update a Product details and redirects to the show page' do
      put "/products/#{product_brand.id}", params: { product: product_brand.attributes }

      expect(response).to redirect_to product_path(brand.products.last.id)
      follow_redirect!
      expect(response.body).to include('Test product 3')
    end
  end

  describe '#destroy' do
    let!(:product_brand) { create(:product, brand: brand) }
    it 'destroy a Product and redirects to index page' do
      expect { delete product_path(product_brand.id) }.to change(Product, :count).by (-1)
      expect(response).to redirect_to products_path
    end
  end

  describe '#search' do
    let!(:product_brand) { create(:product, brand: brand) }
    it 'search Products by title' do
      get '/search?search=test+product'

      expect(response.body).to include('Test product 5')
      expect(response).to have_http_status(200)
    end
  end
end
