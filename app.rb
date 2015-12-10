require 'sinatra'
require 'rack/throttle'
require 'marky_markov'

use Rack::Throttle::Interval

# def filtered(text_file)
#   text_file.read.split.map(&:strip).select {|w| /\b[a-zA-Z]+\b/ =~ w}
# end
#
# WORDS = filtered('13888-8.txt') +
#         filtered('50650-0.txt') +
#         filtered('50651-8.txt').join(' ')

$markov = MarkyMarkov::Dictionary.new('dictionary')

Struct.new('Story', :title, :paragraphs)

def generate_story
  t = $markov.generate_n_words(rand(4) + 3)
  ps = [
    $markov.generate_n_sentences(2),
    $markov.generate_n_sentences(1),
    $markov.generate_n_sentences(3),
  ]

  t = t.gsub(/_/, '').split(' ').map {|w| w[0].upcase + w[1..-1]}.join(' ')
  ps = ps.map {|p|
    p = p.gsub(/[_'"\[\]]/, '')
    p[0].upcase + p[1..-1]
  }

  Struct::Story.new(t, ps)
end

get('/') do
  sleep 1
  redirect '/story'
end

get('/phrase') do
end

get('/story') do
  story = generate_story

  %[
  <!doctype html>
  <head>
    <title>Pass-story Generator 1.0</title>
  </head>
  <body>
    <div style='width: 600px; margin: 0 auto;'>
      <h1>#{ story.title }</h1>
      #{ story.paragraphs.map {|p| "<p>#{ p }</p>"}.join("\n") }
      <a href='/story' style='display:block;text-align:center;margin-top:32px;font-weight:bold;'>AGAIN</a></center>
    </div>
  </body>
  ]
end
