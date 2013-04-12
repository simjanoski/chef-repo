#
# Cookbook Name:: saas-admin-deployer
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# This allows chef to create users and their passwords
gem_package "ruby-shadow" do
  action :install
end
 
# Create a unix group
group "saasadmins" do
     gid 100001
end

#create user
user "saasadmin" do
     comment "SaaS admin"
     uid 10001
     gid "saasadmins"
     home "/home/saasadmin"
     shell "/bin/bash"
     password "$1$2QYepl2p$.7ckFmevVtpBZpokJCuSd."
end

# Create a directory
directory "/opt/tomcat/" do
     owner "root"
     mode "0755"
     action :create
     recursive true
end

#run a bash shell -  download and extract tomcat
bash "install_tomcat" do	
     user "root"
     cwd "/opt/tomcat"	
     code <<-EOH
       wget http://www.gtlib.gatech.edu/pub/apache/tomcat/tomcat-7/v7.0.39/bin/apache-tomcat-7.0.39.tar.gz
       tar -xzf apache-tomcat-7.0.39.tar.gz
       rm -rf apache-tomcat-7.0.39.tar.gz
       cd /opt
       chown saasadmin:saasadmins -R tomcat/*
     EOH
     not_if "test -d /opt/tomcat/apache-tomcat-7.0.39"
end


