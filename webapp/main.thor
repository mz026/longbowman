class Webapp < Thor::Group
  include Thor::Actions
  argument :name

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_bowerrc
    copy_file "templates/.bowerrc", "#{name}/.bowerrc"
  end

end
