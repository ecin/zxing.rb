lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

def fixture_image(image)
  File.expand_path("../fixtures/#{image}.png", __FILE__)
end