namespace :webpacker do
  namespace :install do
    desc "Install everything needed for routes"
    task routes: ["webpacker:verify_install"] do
      template = File.expand_path("../../install/template.rb", __dir__)
      command = Rails::VERSION::MAJOR >= 5 ? 'rails app' : 'rake rails'
      arguments = "LOCATION=#{template} WEBPACKER_ROUTES_INSTALL=true"
      exec "#{RbConfig.ruby} ./bin/#{command}:template #{arguments}"
    end
  end

  namespace :routes do
    desc "Verifies if routes is installed"
    task verify_install: ["webpacker:verify_install"] do
      if Webpacker.config.routes_path.exist?
        $stdout.puts "Webpacker Routes is installed 🎉 🍰"
        $stdout.puts "Using #{Webpacker.config.routes_path} directory for generating routes"
      else
        $stderr.puts "Webpacker Routes directory not found. \n"\
            "Make sure webpacker:install:routes is run successfully before " \
            "running dependent tasks"
        exit!
      end
    end

    desc "Generate routes package"
    task generate: [:verify_install, :environment] do
      Webpacker::Routes.generate(Rails.application)
    end
  end
end
