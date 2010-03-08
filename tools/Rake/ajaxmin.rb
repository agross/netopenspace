class Minify
	def self.javascript(attributes)
		patch_opts!(attributes, "-JS")
		
		run(attributes)
	end
	
	def self.css(attributes)
		patch_opts!(attributes, "-CSS")
		
		run(attributes)
	end
	
	def self.patch_opts!(attributes, mode)
		opts = attributes.fetch(:opts, [])
		
		opts = opts.reverse.push(mode).reverse
		attributes[:opts] = opts
	end
	
	def self.run(attributes)
		tool = attributes.fetch(:tool)
		source = attributes.fetch(:source)
		destination = attributes.fetch(:destination)
		opts = attributes.fetch(:opts, [])
		
		FileUtils.mkdir_p destination.dirname
		
		ajaxmin = tool.to_absolute

		sh ajaxmin, "-clobber:true", "-enc:in", "UTF-8", "-enc:out", "UTF-8", "-term", "-out", destination, *(opts + source)
	end
end