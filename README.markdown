# Roles for Active Record

Roles for Active Record is a full AR implementation of the [Roles generic API](https://github.com/kristianmandrup/roles_generic/wiki)

## Install

<code>gem install roles_active_record</code>

## Role strategies

The following Role strategies are available for Active Record:

* admin_flag
* roles_mask
* role_string
* many_roles
* one_role

The strategies :one_role and :many_roles employ a separate Role model (table), the other strategies all use an inline attribute on the User model. 

## Rails generator

The Roles Generator will create :admin and :guest roles by default

<code>$ rails g active_record:roles User --strategy admin_flag --roles editor blogger</code>

## Usage

Example: :admin_flag Role strategy

<code>$ rails g active_record:roles User admin_flag</code>

Example: admin_flag Role strategy (generate migrations only)

<code>$ rails g active_record:roles_migration User admin_flag</code>

## Example : admin_flag

:admin_flag strategy configuration:
<pre>use_roles_strategy :admin_flag

class User < ActiveRecord::Base    
  include Roles::ActiveRecord 
    
  strategy :admin_flag, :default
  valid_roles_are :admin, :guest
end
</pre>

## Example : one_role

For strategies that use a separate Role model you must call the class method #role_class with the name of the role class

:one_role strategy configuration:
<pre>use_roles_strategy :one_role
class User < ActiveRecord::Base
  include Roles::ActiveRecord 

  strategy :one_role, :default
  role_class :role

  valid_roles_are :admin, :guest
end
</pre>
    
## Roles generators

The library comes with Rails 3 generators that let you populate a User model with a given role strategy
The generators available are: 

* active_record:roles
* active_record:roles_migration

### Roles generator

Apply :admin_flag Role strategy to User model using default roles :admin and :guest (default)

<code>$ rails g active_record:roles User --strategy admin_flag</code>

Apply :admin_flag Role strategy to User model using default roles and extra role :author

<code>$ rails g active_record:roles_migration User --strategy admin_flag --roles author</code>

Apply :one_role Role strategy to User model without default roles, only with roles :user, :special and :editor

<code>$ rails g active_record:roles_migration User --strategy one_role --roles user special editor --no-default-roles</code>

### Roles migration generator

Example: admin_flag Role strategy - generate migrations and model files

<code>$ rails g active_record:roles_migration User --strategy admin_flag</code>

Create reverse migration

<code>$ rails g active_record:roles_migration User --strategy admin_flag --reverse</code>

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Kristian Mandrup. See LICENSE for details.
