class ModuleField
	attr_accessor :name,:type,:label,:required,:options
	
	def initialize(data)
		@name = data[:name]
    @type = data[:type]
    @label = data[:label]
    @required = data[:required]
    @options = data[:options]
	end
end