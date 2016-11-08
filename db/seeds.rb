# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
5.times do
  Question.create(
    title: Faker::Hipster.sentence.chomp('.'),
    body: Faker::Hipster.paragraph(10, true, 20),
    user: User.first
  )
end

5.times do
  Answer.create(
    body: Faker::Hipster.paragraph(10, true, 10),
    question: Question.first,
    user: User.second
  )
end

3.times do
  Answer.create(
    body: Faker::Lorem.paragraph(10),
    question: Question.second,
    user: User.second
  )
end

2.times do
  Comment.create(
    commentable: Question.first,
    user: User.second,
    body: Faker::Hacker.say_something_smart
  )

  Comment.create(
    commentable: Answer.second,
    user: User.second,
    body: Faker::Hacker.say_something_smart
  )
end
