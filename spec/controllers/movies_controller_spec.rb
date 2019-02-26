require 'spec_helper'
require 'rails_helper'
AUTOFEATURE = true
  
describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @faker_results = [double('movie1'), double('movie2')]
    end
    it 'should call the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('hardware').and_return(@faker_results)
      post :search_tmdb, params: {:search_terms => 'hardware'}
    end
    context 'after valid search' do
      before :each do
        allow(Movie).to receive(:find_in_tmdb).and_return(@faker_results)
        post :search_tmdb, params: {:search_terms => 'hardware'}
      end
      it 'should select the Search Results template for rendering' do
        expect(response).to render_template('search_tmdb')
      end
      it 'should make the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@faker_results)
      end
    end
  end
end