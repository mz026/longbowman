module Longbowman
  class Ember < Thor
    include Thor::Actions
    argument :name

    def self.source_root
      File.join(File.dirname(__FILE__), '..')
    end

    desc "app", "create app"
    def app
      ensure_bower_exists
      create_bowerrc
      create_index_html
      setup_ember
      create_gitignore
      create_test_files
      setup_testem
    end

    desc "controller (in your javascripts folder)", "create ember controller"
    def controller
      camel_name = Thor::Util.camel_case(name)
      template "templates/controller.js.erb", "controllers/#{name}_controller.js",
        { :camel_name => camel_name, :snake_name => name }
    end

    desc "view (in your javascripts folder)", "create ember view and template"
    def view
      camel_name = Thor::Util.camel_case(name)
      uncapitalized_camel_name = uncalpitalize(camel_name)

      template "templates/html_template.html.erb", "templates/#{name}_template.html",
        :snake_name => name

      template "templates/view.js.erb", "views/#{name}_view.js",
        :camel_name => camel_name, 
        :uncapitalized_camel_name => uncapitalized_camel_name,
        :snake_name => name

    end

    no_tasks do
      def uncalpitalize str
        str[0].downcase + str[1..-1]
      end
    end

    no_tasks do
      def ensure_bower_exists
        raise Exception, "install bower first!" unless command_exists? "bower"
      end

      def create_bowerrc
        copy_file "templates/.bowerrc", "#{name}/.bowerrc"
      end

      def create_index_html
        inside name do
          run "bower install -s jquery requirejs requirejs-text"
        end
        template "templates/index.html.erb", "#{name}/index.html"
      end

      def setup_ember
        inside name do
          run "bower install -s ember"
        end
        template "templates/javascripts/main.js.erb", "#{name}/javascripts/main.js"
        template "templates/javascripts/router.js.erb", "#{name}/javascripts/router.js"
      end

      def create_gitignore
        copy_file "templates/gitignore", "#{name}/.gitignore"
      end

      def create_test_files
        return unless yes?("use mocha?", :blue)

        inside name do
          run "bower install -s mocha chai sinon.js"
        end
        testem = command_exists? "testem"
        template "templates/spec_runner.html.erb", 
          "#{name}/spec_runner.html",
          { :testem => testem }
        template "templates/javascripts/spec_runner.js", 
          "#{name}/javascripts/spec_runner.js"
        copy_file "templates/javascripts/spec/dummy.test.js",
          "#{name}/javascripts/spec/dummy.test.js"
      end

      def setup_testem
        if command_exists? "testem"
          copy_file "templates/testem.json", "#{name}/testem.json"
        end
      end

    end

    no_tasks do
      def command_exists? command
        ! `which #{command}`.empty?
      end
    end

  end
end
