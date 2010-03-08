class Minify
	def self.javascript(attributes)
		tool = attributes.fetch(:tool)
		source = attributes.fetch(:source)
		destination = attributes.fetch(:destination)
		
		FileUtils.mkdir_p destination.dirname
		
		ajaxmin = tool.to_absolute
		
		sh ajaxmin, "-clobber:true", "-enc:in", "UTF-8", "-enc:out", "UTF-8", "-term", "-out", destination, *(source)
	end
	
	def self.css(attributes)
		tool = attributes.fetch(:tool)
		source = attributes.fetch(:source)
		destination = attributes.fetch(:destination)
		
		FileUtils.mkdir_p destination.dirname
		
		ajaxmin = tool.to_absolute
		
		sh ajaxmin, "-clobber:true", "-enc:in", "UTF-8", "-enc:out", "UTF-8", "-term", "-out", destination, *(source)
	end
end