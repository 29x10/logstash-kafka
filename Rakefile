require "logstash/devutils/rake"

require 'jars/installer'
task :install_jars do
  Jars::JarInstaller.new.vendor_jars
  #Jars::JarInstaller.new.install_jars
end
