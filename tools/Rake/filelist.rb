class FileList
	def copy_hierarchy(attributes)
		self.each do |source|
			target = source.pathmap("%{^#{attributes[:source_dir]},#{attributes[:target_dir]}}p") 
			FileUtils.mkdir_p target.dirname
			FileUtils.cp source,
				target,
				:verbose => false,
				:preserve => true
		end
	end
end