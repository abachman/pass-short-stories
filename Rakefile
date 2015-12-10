require 'marky_markov'

task :regenerate do
  markov = MarkyMarkov::Dictionary.new('dictionary')
  markov.clear!
  Dir['text-sources/*.txt'].each do |source|
    puts "Adding #{ source }..."
    markov.parse_file(source)
  end
  markov.save_dictionary! # Saves the modified dictionary/creates one if it didn't exist.
  puts "Updated #{ markov.dictionarylocation }"
end
