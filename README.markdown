# Roles for Active Record

An Active Record implementation of [roles generic](http://github.com/kristianmandrup/roles_generic)

## Install

<code>gem install roles_active_record</code>

## Update!

Now implements the [roles generic](http://github.com/kristianmandrup/roles_generic) Roles API
It also implements the following Role strategies:

* admin_flag
* many_roles
* one_role
* roles_mask
* role_string

## Rails generator

Needs some more refactoring (see notes below!)

<code>$ rails g active_record:roles User --strategy admin_flag --roles admin guest</code>

## Usage

Example: admin_flag Role strategy - generate migrations and model files

<code>$ rails g active_record:roles User admin_flag</code>

Example: admin_flag Role strategy - generate migrations only

<code>$ rails g active_record:roles_migration User admin_flag</code>

## Role strategies

The library comes with the following role strategies built-in:

Single role:

* admin_flag
* role_string
* one_role  

Multi role:

* many_roles
* roles_mask


### Admin flag

Boolean *admin_flag* on User to indicate if user role is admin or normal user 

### Role string

String *role_string* on User that names the role

### One role

*role_id* relation to *id* of *Roles* table that contain all valid roles  

### Many roles

*role_id* relation to *UserRoles* table that is the join table that joins a user to multiple roles in the *Roles* tables.

### Roles mask

*roles_mask* integer that as a bitmask indicating which roles out of a set of valid roles that the user has.

Note: The following examples use RSpec to demonstrate usage scenarios.

## Example : admin_flag

<pre>use_roles_strategy :admin_flag

class User < ActiveRecord::Base    
  include Roles::ActiveRecord 
    
  strategy :admin_flag, :default
  valid_roles_are :admin, :guest
end
</pre>

## Example : role_string

<pre>use_roles_strategy :role_string

class User < ActiveRecord::Base
  include Roles::ActiveRecord 
  
  strategy :role_string, :default
  valid_roles_are :admin, :guest   
end
</pre>

## Example : one_role

<pre>use_roles_strategy :one_role
class User < ActiveRecord::Base
  include Roles::ActiveRecord 

  strategy :one_role, :default
  role_class :role

  valid_roles_are :admin, :guest
end
</pre>
    
## Example : many_roles

<pre>use_roles_strategy :many_roles
class User < ActiveRecord::Base    
  include Roles::ActiveRecord

  strategy :many_roles, :default
  role_class :role

  valid_roles_are :admin, :guest
end
</pre>

## Example : roles_mask

<pre>use_roles_strategy :roles_mask

class User < ActiveRecord::Base    
  include Roles::ActiveRecord
  
  strategy :roles_mask, :default
  valid_roles_are :admin, :guest   
end

</pre>

## Rails generators

The library comes with a Rails 3 generator that lets you populate a user model with a given role strategy 
The following role strategies are included by default. Add your own by adding extra files inside the strategy folder, one file for each role strategy is recommended.

* admin_flag
* role_string
* roles_mask
* one_role
* many_roles
          
_Important:_ 

The generators are a bit rusty and needs to be updated to take advantage of the [rails3_artifactor](http://github.com/kristianmandrup/rails3_artifactor) 
Please see the [roles mongoid](http://github.com/kristianmandrup/roles_mongoid) for an example. You are most welcome to submit a patch to make it work for AR ;) 

### Generators

* active_record:roles
* active_record:roles_migration

Example: admin_flag Role strategy - generate migrations and model files

<code>$ rails g active_record:roles User admin_flag</code>

Example: admin_flag Role strategy - generate migrations only

<code>$ rails g active_record:roles_migration User admin_flag</code>

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
