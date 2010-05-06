# RubySugar

Ruby wrapper for the [SugarCRM API](http://developers.sugarcrm.com/docs/OS/5.5/Developer_Guides/-docs-Developer_Guides-Sugar_Developer_Guide_5.5-Chapter%202%20Application%20Framework.html#9000253).

Note, the result sets returned from this gem are intentionally generic.  Implementing specific usages of this data are left up to your specific program.

## Installation

    sudo gem install ruby_sugar

## Usage

### Authenticate

SugarCRM does not support OAuth, so you're stuck with standard user/password.

    require 'ruby_sugar'

    # create the client
    client = RubySugar::Client.new('user','password','http[s]://link.to.sugar')

    #login to get session
    client.login

### Examples

    #Get a list of the modules that you have access to
    modules = rs.get_available_modules

    #loop through the modules and list the entries in each module
    modules.each {|mod| puts "Module Name: #{mod}"}

    #Get a list of contacts
    contacts = rs.get_entry_list('Contacts')
    contacts.each {|contact| contact.each {|entry| puts entry[:name]+' - '+entry[:value]}}

    #Get a list of leads
    leads = rs.get_entry_list('Leads')
    leads.each {|lead| lead.each {|entry| puts entry[:name]+' - '+entry[:value]}}

## TODO

## Copyright

Copyright (c) 2010 [Josh Dennis](http://joshdennis.net). See LICENSE for details.