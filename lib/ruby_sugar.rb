require 'rubygems'
require 'soap/wsdlDriver'
require 'digest/md5'

module RubySugar

end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'ruby_sugar', 'client')
require File.join(directory, 'ruby_sugar', 'module_field')