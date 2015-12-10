require 'sinatra'
require 'rack/throttle'
require 'marky_markov'

## Uncomment if you need to throttle traffic. Default to 1 second minimum timeout.
# use Rack::Throttle::Interval, min: 1.0

# run `rake regenerate` if you make changes to the source texts.
$markov = MarkyMarkov::Dictionary.new('dictionary')

Struct.new('Story', :title, :paragraphs)

def generate_story
  t = $markov.generate_n_words(rand(4) + 3)
  ps = [
    $markov.generate_n_sentences(2),
    $markov.generate_n_sentences(1),
    $markov.generate_n_sentences(3),
  ]

  # clean up text
  t = t.gsub(/_/, '').split(' ').map {|w|
    # title-case each word
    w[0].upcase + w[1..-1]
  }.join(' ')

  # clean up text and start with uppercase letter for each paragraph
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

get('/phrases') do
  # generate more secure passphrases here...
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
      <a href='https://github.com/abachman/pass-short-stories' style='display:block;text-align:center;margin-top:32px;font-weight:bold;'>https://github.com/abachman/pass-short-stories</a></center>
    </div>
  </body>
  ]
end
