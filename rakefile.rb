require 'rake/clean'
require 'configatron'
require 'dictionary'
Dir.glob(File.join(File.dirname(__FILE__), 'tools/Rake/*.rb')).each do |f|
	require f
end

task :default => [:clobber, 'compile:all', 'tests:run', 'package:all']

namespace :env do
	Rake::EnvTask.new do |env|
		env.configure_from = 'properties.yml'
		env.configure_environments_with = lambda do |env_name|
			configure_env_for env_name
		end
	end

	def configure_env_for(env_key)
		env_key = env_key || 'development'

		puts "Loading settings for the '#{env_key}' environment"
		
		yaml = Configuration.load_yaml 'properties.yml', :hash => env_key, :inherit => :default_to, :override_with => :local_properties
		configatron.configure_from_hash yaml
		
		configatron.app.debugging_enabled = configatron.build.configuration == 'Debug'
		configatron.deployment.package = "#{configatron.project}-#{configatron.build.number || '1.0.0.0'}.zip".in(configatron.dir.deploy)

		CLEAN.clear
		CLEAN.include('teamcity-info.xml')
		CLEAN.include('**/obj'.in(configatron.dir.source))
		CLEAN.include('**/*'.in(configatron.dir.test_results))
				
		CLOBBER.clear
		CLOBBER.include(configatron.dir.build)
		CLOBBER.include(configatron.dir.deploy)
		CLOBBER.exclude('NOS.Wiki/bin'.in(configatron.dir.app))
		CLOBBER.include('**/bin'.in(configatron.dir.source))
		CLOBBER.include('**/*.template'.in(configatron.dir.source))
		CLOBBER.include('**/*.generated.*'.in(configatron.dir.source))
		# Clean template results.
		CLOBBER.map! do |f|
			next f.ext() if f.pathmap('%x') == '.template'
			f
		end
		
		configatron.protect_all!

		puts configatron.inspect
	end

	# Load the default environment configuration if no environment is passed on the command line.
	Rake::Task['env:development'].invoke \
		if not Rake.application.options.show_tasks and
		   not Rake.application.options.show_prereqs and
		   not Rake.application.top_level_tasks.any? do |t|
			/^env:/.match(t)
		end
end
	
namespace :generate do
	desc 'Updates the version information for the build'
	task :version do
		next if configatron.build.number.nil?
		
		asmInfo = AssemblyInfoBuilder.new({
				:AssemblyFileVersion => configatron.build.number,
				:AssemblyVersion => configatron.build.number,
				:AssemblyInformationalVersion => configatron.build.number,
				:AssemblyDescription => "#{configatron.build.number} / #{configatron.build.commit_sha}",
			})
			
		asmInfo.write 'VersionInfo.cs'.in(configatron.dir.source)
	end

	desc 'Updates the configuration files for the build'
	task :config do
		FileList.new("#{configatron.dir.source}/**/*.template").each do |template|
			QuickTemplate.new(template).exec(configatron)
		end
	end
	
	desc 'Minifies and packages up JavaScript files'
	task :javascript do
		scripts = FileList.new("#{configatron.dir.app}/#{configatron.project}.Wiki/Themes/#{configatron.project}/includes/*.js")
		
		Minify.javascript \
			:tool => configatron.tools.ajaxmin,
			:pretty => configatron.app.debugging_enabled,
			:source => scripts,
			:destination => "#{configatron.dir.app}/#{configatron.project}.Wiki/Themes/#{configatron.project}/#{configatron.project}.generated.js"
	end
	
	desc 'Minifies and packages up CSS files'
	task :css do
		css = FileList.new("#{configatron.dir.app}/#{configatron.project}.Wiki/Themes/#{configatron.project}/includes/*.css")
		
		Minify.css \
			:tool => configatron.tools.ajaxmin,
			:pretty => configatron.app.debugging_enabled,
			:opts => ["-comments:hacks"],
			:source => css,
			:destination => "#{configatron.dir.app}/#{configatron.project}.Wiki/Themes/#{configatron.project}/#{configatron.project}.generated.css"
	end
end

namespace :compile do
	desc 'Compiles the application'
	task :app => [:clobber, 'generate:version', 'generate:config', 'generate:javascript', 'generate:css'] do
		FileList.new("#{configatron.dir.app}/**/*.csproj").each do |project|
			MSBuild.compile \
				:project => project,
				:properties => {
					:SolutionDir => configatron.dir.source.to_absolute.chomp('/').concat('/').escape,
					:Configuration => configatron.build.configuration,
					:TreatWarningsAsErrors => true
				}
		end
	end

	desc 'Compiles the tests'
	task :tests => [:clobber, 'generate:version', 'generate:config'] do
		FileList.new("#{configatron.dir.test}/**/*.Tests.csproj").each do |project|
			MSBuild.compile \
				:project => project,
				:properties => {
					:SolutionDir => configatron.dir.source.to_absolute.chomp('/').concat('/').escape,
					:Configuration => configatron.build.configuration
				}
		end
	end
	
	task :all => [:app, :tests]
end

namespace :tests do
	desc 'Runs unit tests'
	task :run => ['compile:tests'] do
		FileList.new("#{configatron.dir.build}/Tests/**/*.Tests.dll").each do |assembly|
			Mspec.run \
				:tool => configatron.tools.mspec,
				:reportdirectory => configatron.dir.test_results,
				:assembly => assembly
		end
	end
	
	desc 'Runs CLOC to create some source code statistics'
	task :cloc do
		results = Cloc.count_loc \
			:tool => configatron.tools.cloc,
			:report_file => 'cloc.xml'.in(configatron.dir.test_results),
			:search_dir => configatron.dir.source,
			:statistics => {
				:'LOC.CS' => '/results/languages/language[@name=\'C#\']/@code',
				:'Files.CS' => '/results/languages/language[@name=\'C#\']/@files_count',
				:'LOC.Total' => '/results/languages/total/@code',
				:'Files.Total' => '/results/languages/total/@sum_files'
			} do |key, value|
				TeamCity.add_statistic key, value
			end
		
		TeamCity.append_build_status_text "#{results[:'LOC.CS']} LOC in #{results[:'Files.CS']} C# Files"
	end
	
	desc 'Runs NCover code coverage'
	task :ncover => ['compile:tests'] do
		applicationAssemblies = FileList.new() \
			.include("#{configatron.dir.build}/Tests/**/#{configatron.project}*.dll") \
			.exclude(/(Tests\.dll$)|(ForTesting\.dll$)/) \
			.pathmap('%n') \
			.join(';')
			
		FileList.new("#{configatron.dir.build}/Tests/**/*.Tests.dll").each do |assembly|
			NCover.run_coverage \
				:tool => configatron.tools.ncover,
				:report_dir => configatron.dir.test_results,
				:working_dir => assembly.dirname,
				:application_assemblies => applicationAssemblies,
				:program => configatron.tools.mspec,
				:assembly => assembly.to_absolute.escape,
				:args => ["#{('--teamcity ' if ENV['TEAMCITY_PROJECT_NAME']) || ''}"]
		end
		
		NCover.explore \
			:tool => configatron.tools.ncoverexplorer,
			:project => configatron.project,
			:report_dir => configatron.dir.test_results,
			:html_report => 'Coverage.html',
			:xml_report => 'Coverage.xml',
			:min_coverage => 80,
			:fail_if_under_min_coverage => false,
			:statistics => {
				:NCoverCodeCoverage => "/coverageReport/project/@functionCoverage"
			} do |key, value|
				TeamCity.add_statistic key, value
				TeamCity.append_build_status_text "Code coverage: #{Float(value.to_s).round}%"
			end
	end
	
	desc 'Runs FxCop to analyze assemblies for compliance with the coding guidelines'
	task :fxcop => [:clean, 'compile:app'] do
		results = FxCop.analyze \
			:tool => configatron.tools.fxcop,
			:project => 'Settings.FxCop'.in(configatron.dir.source),
			:report => 'FxCop.html'.in(configatron.dir.test_results),
			:apply_report_xsl => true,
			:report_xsl => 'CustomFxCopReport.xsl'.in("#{configatron.tools.fxcop.dirname}/Xml"),
			:console_output => true,
			:console_xsl => 'FxCopRichConsoleOutput.xsl'.in("#{configatron.tools.fxcop.dirname}/Xml"),
			:show_summary => true,
			:fail_on_error => false,
			:library_dirs => "#{configatron.dir.app}/#{configatron.project}.Wiki/bin",
			:assemblies => FileList.new() \
				.include("#{configatron.dir.app}/#{configatron.project}.Wiki/**/#{configatron.project}*.dll") \
				.exclude('**/*.vshost') \
			do |violations|
				TeamCity.append_build_status_text "#{violations} FxCop violation(s)"
				TeamCity.add_statistic 'FxCopViolations', violations
			end	
	end
	
	desc 'Runs StyleCop to analyze C# source code for compliance with the coding guidelines'
	task :stylecop do
		results = StyleCop.analyze \
			:tool => configatron.tools.stylecop,
			:directories => configatron.dir.app,
			:ignore_file_pattern => ['(?:Version|Solution|Assembly|FxCop)Info\.cs$', '\.Designer\.cs$', '\.(as.x|master)\.cs$', '\\\\public\\\\.*'],
			:settings_file => 'Settings.StyleCop'.in(configatron.dir.source),
			:report => 'StyleCop.xml'.in(configatron.dir.test_results),
			:report_xsl => 'StyleCopReport.xsl'.in(configatron.tools.stylecop.dirname) \
			do |violations|
				TeamCity.append_build_status_text "#{violations} StyleCop violation(s)"
				TeamCity.add_statistic 'StyleCopViolations', violations
			end
	end
	
	desc 'Run all code quality-related tasks'
	task :quality => [:ncover, :cloc, :fxcop, :stylecop]
end

namespace :package do
	desc 'Prepares the year\'s web application for packaging'
	task :webapp => ['compile:app'] do
		sourceDir = "#{configatron.dir.app}/#{configatron.project}.Wiki"
		webAppFiles = FileList.new() \
					.include("#{sourceDir}/**/*.deploy") \
					.include("#{sourceDir}/**/*.txt") \
					.include("#{sourceDir}/**/*.as?x") \
					.include("#{sourceDir}/**/*.ascx.cs") \
					.include("#{sourceDir}/**/*.master") \
					.include("#{sourceDir}/**/*.gif") \
					.include("#{sourceDir}/**/*.jpeg") \
					.include("#{sourceDir}/**/*.png") \
					.include("#{sourceDir}/**/*.ico") \
					.include("#{sourceDir}/**/*.js") \
					.include("#{sourceDir}/**/*.css") \
					.include("#{sourceDir}/**/*.dll") \
					.include("#{sourceDir}/**/*.pdb") \
					.include("#{sourceDir}/**/*.config") \
					.include("#{sourceDir}/**/*.resx") \
					.include("#{sourceDir}/**/*.htm") \
					.include("#{sourceDir}/**/*.html") \
					.include("#{sourceDir}/**/*.swf") \
					.exclude("#{sourceDir}/Themes/#{configatron.project}/includes/") \
					.include("#{sourceDir}/public/Plugins/**/*.cs") \
					.include("#{sourceDir}/public/Snippets/") \
					.include("#{sourceDir}/public/Upload/") \
					.include("#{sourceDir}/public/AccessDeniedNotice.cs") \
					.include("#{sourceDir}/public/AccountActivationMessage.cs") \
					.include("#{sourceDir}/public/ApproveDraftMessage.cs") \
					.include("#{sourceDir}/public/AutoRegistration*.cs") \
					.include("#{sourceDir}/public/DiscussionChangeMessage.cs") \
					.include("#{sourceDir}/public/EditNotice.cs") \
					.include("#{sourceDir}/public/Footer.cs") \
					.include("#{sourceDir}/public/Header.cs") \
					.include("#{sourceDir}/public/HtmlHead.cs") \
					.include("#{sourceDir}/public/LoginNotice.cs") \
					.include("#{sourceDir}/public/PageChangeMessage.cs") \
					.include("#{sourceDir}/public/PageFooter.cs") \
					.include("#{sourceDir}/public/PageHeader.cs") \
					.include("#{sourceDir}/public/PasswordResetProcedureMessage.cs") \
					.include("#{sourceDir}/public/RegisterNotice.cs") \
					.include("#{sourceDir}/public/Sidebar.cs")

		webAppFiles.copy_hierarchy \
			:source_dir => sourceDir, 
			:target_dir => "Wiki".in(configatron.dir.for_deployment).to_absolute
	end
	
	desc 'Prepares the Twitter Wall for packaging'
	task :wall => ['generate:css', 'generate:javascript'] do
		sourceDir = "#{configatron.dir.app}/#{configatron.project}.Wall"
		files = FileList.new() \
					.include("#{sourceDir}/**/*.*") \
					.exclude("**/*.template")

		files.copy_hierarchy \
			:source_dir => sourceDir, 
			:target_dir => "Wall".in(configatron.dir.for_deployment).to_absolute
	end
	
	desc 'Prepares the root web application for packaging'
	task :root => ['compile:app'] do
		sourceDir = "#{configatron.dir.app}/#{configatron.project}.Root"
		rootFiles = FileList.new() \
					.include("#{sourceDir}/**/*.*") \
					.exclude("**/*.template")

		rootFiles.copy_hierarchy \
			:source_dir => sourceDir, 
			:target_dir => "Root".in(configatron.dir.for_deployment).to_absolute
	end

	desc 'Creates a zipped archive for deployment'
	task :zip => [:webapp, :root, :wall] do
		sz = SevenZip.new \
			:tool => configatron.tools.zip,
			:zip_name => configatron.deployment.package
			
		Dir.chdir(configatron.dir.for_deployment) do
			sz.zip :files => FileList.new("**/*")
		end
	end
	
	task :all => [:zip]
end

namespace :deploy do
	task :root, :remote, :needs => ['package:all'] do |t, args|
		remote = args[:remote]
		
		MSDeploy.run \
			:tool => configatron.tools.msdeploy,
			:log_file => configatron.deployment.logfile,
			:verb => :sync,
			:allowUntrusted => configatron.deployment.connection.allow_untrusted_https,
			:source => Dictionary[:contentPath, "Root".in(configatron.dir.for_deployment).to_absolute.escape],
			:dest => remote.merge({
				:contentPath => "#{configatron.deployment.iis.app_name}".escape
				}),
			:usechecksum => true,
			:enableRule => ["DoNotDeleteRule", "SkipNewerFilesRule"]
	end
	
	task :wiki, :remote, :needs => ['package:all'] do |t, args|
		remote = args[:remote]
		
		MSDeploy.run \
			:tool => configatron.tools.msdeploy,
			:log_file => configatron.deployment.logfile,
			:verb => :sync,
			:allowUntrusted => configatron.deployment.connection.allow_untrusted_https,
			:source => Dictionary[:contentPath, "Wiki/App_Offline.htm.deploy".in(configatron.dir.for_deployment).to_absolute.escape],
			:dest => remote.merge({
				:contentPath => "#{configatron.deployment.iis.app_name}#{configatron.app.iis.cookie_path}App_Offline.htm".escape
				})

		MSDeploy.run \
			:tool => configatron.tools.msdeploy,
			:log_file => configatron.deployment.logfile,
			:verb => :sync,
			:allowUntrusted => configatron.deployment.connection.allow_untrusted_https,
			:source => Dictionary[:contentPath, "Wiki".in(configatron.dir.for_deployment).to_absolute.escape],
			:dest => remote.merge({
				:contentPath => "#{configatron.deployment.iis.app_name}#{configatron.app.iis.cookie_path}".escape
				}),
			:usechecksum => true,
			:skip =>[
				Dictionary[
					:objectName, "filePath",
					:skipAction, "Delete",
					:absolutePath, "App_Offline\\.htm$"
				],
				Dictionary[
					:objectName, "filePath",
					:skipAction, "Delete",
					:absolutePath, "/public\\\\.*$"
				],
				Dictionary[
					:objectName, "dirPath",
					:skipAction, "Delete",
					:absolutePath, "/public.*$"
				]
			]
			
		MSDeploy.run \
			:tool => configatron.tools.msdeploy,
			:log_file => configatron.deployment.logfile,
			:verb => :delete,
			:allowUntrusted => configatron.deployment.connection.allow_untrusted_https,
			:dest => remote.merge({
				:contentPath => "#{configatron.deployment.iis.app_name}#{configatron.app.iis.cookie_path}App_Offline.htm".escape
				})
	end
	
	task :wall, :remote, :needs => ['package:all'] do |t, args|
		remote = args[:remote]
		
		MSDeploy.run \
			:tool => configatron.tools.msdeploy,
			:log_file => configatron.deployment.logfile,
			:verb => :sync,
			:allowUntrusted => configatron.deployment.connection.allow_untrusted_https,
			:source => Dictionary[:contentPath, "Wall".in(configatron.dir.for_deployment).to_absolute.escape],
			:dest => remote.merge({
				:contentPath => "#{configatron.deployment.iis.app_name}#{configatron.app.iis.cookie_path}/wall".escape
				}),
			:usechecksum => true
	end
	
	desc 'Deploys the build artifacts to QA or production systems'
	task :run do
		remote = Dictionary[]
			
		if configatron.deployment.connection.exists?(:wmsvc) and configatron.deployment.connection.wmsvc
			remote[:wmsvc] = configatron.deployment.connection.address
			remote[:username] = configatron.deployment.connection.user
			remote[:password] = configatron.deployment.connection.password
		else
			remote[:computerName] = configatron.deployment.connection.address
		end
		
		configatron.deployment.tasks.each do |task|
			Rake::Task["deploy:#{task}"].invoke remote
		end
	end
end