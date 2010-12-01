begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "roles_active_record"
    gem.summary = %Q{Implementation of Roles generic API for Active Record}
    gem.description = %Q{Makes it easy to set a role strategy on your User model in Active Record}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/roles_active_record"
    gem.authors = ["Kristian Mandrup"]
    gem.add_development_dependency "rspec",             '>= 2.0.1'
    gem.add_development_dependency 'database_cleaner',  '>= 0.5'
    gem.add_development_dependency "generator-spec",    '>= 0.7.0'

    gem.add_dependency "activerecord",    "~> 3.0.1"
    gem.add_dependency "activesupport",   "~> 3.0.1"
    gem.add_dependency "arel",            ">= 2.0"    
    gem.add_dependency "meta_where",      ">= 0.9.9"
    gem.add_dependency "sugar-high",      "~> 0.3.0"
    gem.add_dependency "require_all",     '~> 1.2.0' 
    gem.add_dependency "roles_generic",   '>= 0.3.2'  
    
    gem.add_dependency 'rails3_artifactor', '>= 0.3.1'
    gem.add_dependency 'logging_assist',    '>= 0.1.6'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
