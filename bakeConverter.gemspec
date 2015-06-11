$:.unshift(File.dirname(__FILE__)+"/")

require "rake"
require "lib/Version"

include FileUtils

#YAML::ENGINE.yamler = 'syck'

PKG_VERSION = BConv::Version.number
PKG_FILES = FileList[
  "lib/**/*.rb"#,
 # "Rakefile.rb",
 # "doc/**/*",
 # "doc/index.html",
 # "license.txt"
]

Gem::Specification.new do |s|
  s.name = "bakeConv"
  s.version = PKG_VERSION
  s.summary = "tbd"
  s.description = "tbd"
  s.files = PKG_FILES.to_a
  s.require_path = "lib"
  s.author = "Frauke Blossey"
  s.email = "frauke.blossey@esrlabs.com"
  s.add_dependency("launchy", "=2.4.3")
  s.rdoc_options = ["-x", "doc"]
  s.executables = ["bakeConv"]
#  s.licenses    = ['MIT']
  s.required_ruby_version = '>= 1.9'
end