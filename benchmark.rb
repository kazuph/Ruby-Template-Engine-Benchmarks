#!/usr/bin/env ruby

# Load everything we need for the benchmark
require 'benchmark'
require 'haml'
require 'tenjin'
require 'liquid'
require 'erb'
require './etanni.rb'

# Load the ERB file
erb_template    = File.open 'templates/template.html.erb', 'r'
erb_template    = erb_template.read

# Load the Etanni file
etanni_template = File.open 'templates/template.xhtml', 'r'
etanni_template = etanni_template.read

# Load the HAML file
haml_template   = File.open 'templates/template.haml', 'r'
haml_template   = haml_template.read

# Load the Liquid file
liquid_template = File.open 'templates/template.liquid', 'r'
liquid_template = liquid_template.read

# Load the Tenjin file
tenjin_template = File.open 'templates/template.rbhtml', 'r'
tenjin_template = tenjin_template.read

# Right, we have all the files. Let's move on.
sleep 1

# Benchmark time! :D
Benchmark.bm(20) do |run|
  # Benchmark the ERB engine
  run.report "ERB" do
    converted= ERB.new erb_template
    converted= converted.result
  end
  
  # Benchmark the Etanni engine
  run.report "Etanni" do
    etanni = Etanni.new etanni_template
    etanni.result nil
  end
  
  # Benchmark the HAML engine
  run.report "HAML" do
    converted= Haml::Engine.new haml_template
    converted.render
  end
  
  # Run the HAML engine without the pretty output
  run.report "HAML-ugly" do
    converted= Haml::Engine.new haml_template, :ugly => true
    converted.render
  end
  
  # Benchmark the Liquid engine
  run.report "Liquid" do
    converted= Liquid::Template.parse liquid_template
    converted.render nil
  end
  
  # Benchmark the Tenjin engine
  run.report "Tenjin" do
    converted = Tenjin::Template.new :cache => false
    converted = converted.convert tenjin_template
  end
  
  # Run Tenjin with cache enabled
  run.report "Tenjin-cache" do
    converted = Tenjin::Template.new :cache => true
    converted = converted.convert tenjin_template
  end
end