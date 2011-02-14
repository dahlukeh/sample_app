require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Example Guy",
                 :email => "example@somewhere.net",
                 :password => "something",
                 :password_confirmation => "something")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example_#{n+1}@somewhere.net"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end

