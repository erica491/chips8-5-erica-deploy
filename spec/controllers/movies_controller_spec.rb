require 'rails_helper'

describe MoviesController, type: :controller do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end

    it 'calls the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('hardware').
        and_return(@fake_results)
      get :search_tmdb, params: { search_terms: 'hardware' }
    end

    describe 'after valid search' do
      before :each do
        allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
        get :search_tmdb, params: { search_terms: 'hardware' }
      end

      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('search_tmdb')
      end

      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end
    end
  end
end


describe MoviesController, type: :controller do
  describe 'adding a movie from TMDb' do
  it 'saves the movie and redirects to search' do
    expect {
      post :add_movie, params: {
        movie: {
          title: 'Hacker',
          rating: 'R',
          release_date: '2020-01-01',
          description: 'A movie about hacking'
        }
      }
    }.to change(Movie, :count).by(1)

    expect(response).to redirect_to(search_tmdb_path)
    expect(flash[:notice]).to include('Hacker was successfully added')
  end
end
end
