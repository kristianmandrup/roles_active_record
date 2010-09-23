begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "roles_active_record"
    gem.summary = %Q{Implementation of Roles generic API for Active Record}
    gem.description = %Q{Makes it easy to set a role strategy on your User model in Active Record}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/roles_for_dm"
    gem.authors = ["Kristian Mandrup"]
    gem.add_development_dependency "rspec", "~> 2.0.0.beta.22" 
    gem.add_development_dependency 'database_cleaner', '~> 0.5.2'
    gem.add_development_dependency "generator-spec",  '~> 0.6.5'

    gem.add_dependency "activerecord",    "~> 3.0.0"
    gem.add_dependency "activesupport",   "~> 3.0.0"
    gem.add_dependency "arel",            "~> 1.0.0"    
    gem.add_dependency "meta_where",      "~> 0.9.3"
    gem.add_dependency "sugar-high",      "~> 0.2.10"
    gem.add_dependency "require_all",     '~> 1.2.0' 
    gem.add_dependency "roles_generic",   '~> 0.2.5'            

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
