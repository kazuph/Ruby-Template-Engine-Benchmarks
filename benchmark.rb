#!/usr/bin/env ruby

# Load everything we need for the benchmark
require 'benchmark'
require 'haml'
require 'tenjin'
require 'liquid'
require 'erb'
require 'lokar'
require './etanni.rb'
require 'erector'

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

# Load the Erector file
erector_template= File.open 'templates/template.erector', 'r'
erector_template= erector_template.read

# Right, we have all the files. Let's move on.
sleep 1

# Amount of times to repeat a run
n = 1000

# Benchmark time! :D
Benchmark.bmbm(20) do |run|
  # == ERB ==
  
  # Benchmark the ERB engine
  run.report "ERB" do
    
    n.times do
      converted= ERB.new erb_template
      converted= converted.result
    end
    
  end
  
  # == ETANNI ==
  
  # Benchmark the Etanni engine
  run.report "Etanni" do

    n.times do
      etanni = Etanni.new etanni_template
      etanni.result nil
    end

  end
  
  # == LOKAR ==
  
  # Benchmark the Lokar engine
  run.report "Lokar" do
    
    n.times do
      lokar = Lokar.parse etanni_template, nil
    end
    
  end
  
  # == ERECTOR ==
  
  # Benchmark the Erector engine
  run.report "Erector" do
    n.times do
      eval erector_template
      html = Kernel.const_get('Template').new.to_html
    end
  end
  
  # Benchmark Erector using Pretty printing
  run.report "Erector-prettyprint" do
    n.times do
      eval erector_template
      html = Kernel.const_get('Template').new.to_html(:prettyprint => true)
    end
  end
  
  # == HAML ==
  
  # Benchmark the HAML engine
  run.report "HAML" do
    
    n.times do
      converted= Haml::Engine.new haml_template
      converted.render
    end

  end
  
  # Run the HAML engine without the pretty output
  run.report "HAML-ugly" do
    
    n.times do  
      converted= Haml::Engine.new haml_template, :ugly => true
      converted.render
    end
    
  end
  
  # == LIQUID ==
  
  # Benchmark the Liquid engine
  run.report "Liquid" do
    
    n.times do    
      converted= Liquid::Template.parse liquid_template
      converted.render nil
    end
    
  end
  
  # == TENJIN ==
  
  # Benchmark the Tenjin engine
  run.report "Tenjin" do
    
    n.times do
      converted = Tenjin::Template.new :cache => false
      converted = converted.convert tenjin_template
    end
    
  end
  
  # Run Tenjin with cache enabled
  run.report "Tenjin-cache" do
    
    n.times do
      converted = Tenjin::Template.new :cache => true
      converted = converted.convert tenjin_template
    end
    
  end
end