# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

genres =  ["Action",
           "Adventure",
           "Comedy",
           "Crime",
           "Faction",
           "Fantasy",
           "Historical",
           "Horror",
           "Mystery",
           "Paranoid",
           "Philosophical",
           "Political",
           "Romance",
           "Saga",
           "Satire",
           "Science fiction",
           "Slice of Life",
           "Speculative",
           "Thriller",
           "Urban"]
genres.each do |genre|
  Genre.find_or_create_by_name(genre)
end
