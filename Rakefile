require 'psych'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "roles_active_record"
    gem.summary = %Q{Implementation of Roles generic API for Active Record}
    gem.description = %Q{Makes it easy to set a role strategy on your User model in Active Record}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/roles_active_record"
    gem.authors = ["Kristian Mandrup"]
    gem.rubygems_version = '1.6.0'
    
    # See Gemfile for regular dependencies
    # COMMENTED OUT TO AVOID DUPLICATION WITH GEMFILE:
    #   https://github.com/technicalpickles/jeweler/issues#issue/152    

    gem.add_development_dependency 'database_cleaner',  '>= 0.6'
    gem.add_development_dependency "rspec",             '>= 2.4.1'
    gem.add_development_dependency "generator-spec",    '>= 0.7.3'
    gem.add_development_dependency 'migration_assist',  '~> 0.2.0'

    gem.add_dependency 'roles_generic', '>= 0.3.8'
    gem.add_dependency 'require_all',   '~> 1.2.0'
    gem.add_dependency 'sugar-high',    '~> 0.4.0'
    gem.add_dependency 'meta_where',    '>= 1.0.1'
            
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
