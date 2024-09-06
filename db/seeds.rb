# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Placez ce code dans db/seeds.rb

require 'open-uri'
require 'json'

puts 'Nettoyage de la base de données...'
Movie.destroy_all

puts 'Création des films...'

# URL de l'API pour les films les mieux notés
url = 'https://tmdb.lewagon.com/movie/top_rated'

# Lire et parser la réponse JSON
response = URI.open(url).read
data = JSON.parse(response)

# URL de base pour les images
base_image_url = 'https://image.tmdb.org/t/p/w500'

# Créer un objet Movie pour chaque film
data['results'].each do |movie_data|
  movie = Movie.create!(
    title: movie_data['title'],
    overview: movie_data['overview'],
    poster_url: base_image_url + movie_data['poster_path'],
    rating: movie_data['vote_average']
  )
  puts "Créé #{movie.title}"
end

puts "Terminé ! #{Movie.count} films créés."
