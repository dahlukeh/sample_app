Factory.define :user do |user|
  user.name                  "Someone"
  user.email                 "me@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person_#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Some message, perhaps important!"
  micropost.association :user
end

