class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end

  def self.find_in_tmdb(search_terms, api_key = ENV.fetch('TMDB_API_KEY', 'test_key'))
    title = search_terms[:title]
    language = search_terms[:language].presence || 'en-US'
    year = search_terms[:release_year]

    params = {
      api_key: api_key,
      query: title,
      language: language
    }
    params[:year] = year if year.present?

    url = "https://api.themoviedb.org/3/search/movie?#{params.to_query}"
    response = Faraday.get(url)
    results = JSON.parse(response.body).fetch('results', [])

    results.map do |result|
      Movie.new(
        title: result['title'],
        release_date: result['release_date'].presence,
        description: result['overview'],
        rating: 'R'
      )
    end
  end

end
