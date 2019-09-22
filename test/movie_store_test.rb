# cd /blah/blah
# ruby -I lib test/movie_store_test.rb

require 'minitest/autorun'
require 'fileutils'
require 'movie'
require 'movie_store'

class MovieStoreTest < Minitest::Test

  Settings = {
      fixture: 'test/fixtures/movies.yml',
      test_file: 'movies_test.yml',
      expected_count: 4
  }

  def setup
    # Copy a test YAML file from a fixture
    FileUtils.cp(Settings[:fixture], Settings[:test_file])
    # Setup a MovieStore instance
    @movie_store = MovieStore.new(Settings[:test_file])
  end

  def teardown
    # Remove the test YAML file
    FileUtils.rm(Settings[:test_file])
  end

  def test_count_returns_expected_number
    assert_equal(Settings[:expected_count], @movie_store.count)
  end

  def test_all_returns_expected_number_of_records
    assert_equal(Settings[:expected_count], @movie_store.all.length)
  end

  def test_all_first_returns_a_movie
    assert_instance_of(Movie, @movie_store.all.first)
  end

  def test_save_movie_creates_new_movie
    movie_store_count = @movie_store.count.to_i

    movie = Movie.new
    movie.title = "Gremlins"
    movie.director = "Joe Dante"
    movie.year = 1984

    @movie_store.save(movie)

    assert_equal(movie_store_count + 1, @movie_store.count)
  end

  def test_save_movie_updates_existent_movie
    movie_id = 2
    movie_title = "Ghostbusters 2"
    movie_year = 1989

    movie_store_count = @movie_store.count.to_i

    movie = @movie_store.find(movie_id)
    movie.title = movie_title
    movie.year = movie_year

    @movie_store.save(movie)

    assert_equal(movie_store_count, @movie_store.count)

    # Updated movie
    updated_movie = @movie_store.find(movie_id)

    assert_equal(movie_title, updated_movie.title)
    assert_equal("Ivan Reitman", updated_movie.director)
    assert_equal(movie_year, updated_movie.year)
  end

  def test_find_returns_a_movie
    assert_instance_of(Movie, @movie_store.find(2))
  end

  def test_find_returns_nil
    assert_nil @movie_store.find(211)
  end

  def test_destroy_deletes_a_movie
    movie_id = 2

    movie_store_count = @movie_store.count.to_i

    # Check that the movie exists
    assert_instance_of( Movie, @movie_store.find(movie_id) )

    @movie_store.destroy(movie_id)

    assert_equal(movie_store_count - 1, @movie_store.count)
    # Test that the movie does not exist
    assert_nil @movie_store.find(movie_id)
  end

  def test_destroy_fails
    movie_id = 211
    movie_store_count = @movie_store.count.to_i

    assert_nil @movie_store.destroy(movie_id)
    # Test Movies count number is the same
    assert_equal(movie_store_count, @movie_store.count)
  end

end
