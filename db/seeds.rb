require "random_data" #requires a separate file of ruby code - often a class
5.times do
    User.create!(
        name: RandomData.random_name,
        email: RandomData.random_email,
        password: RandomData.random_sentence
    )
end

admin = User.create!(
        name: "Admin",
        email: "admin@gmail.com",
        password: "adminn",
        role: "admin"
    )

member = User.create!(
    name: "Member",
    email: "member@gmail.com",
    password: "member"
)

moderator = User.create!(
    name: "Moderator",
    email: "moderator@gmail.com",
    password: "moderator"
    role: "moderator"
)

users = User.all

15.times do
    Topic.create!(
        name: RandomData.random_sentence,
        description: RandomData.random_paragraph
    )
end

topics = Topic.all

50.times do
    Post.create!(
        title: RandomData.random_sentence, #use these methods on the class to create strings for our attributes
        body: RandomData.random_paragraph,
        topic: topics.sample, #array method - picks out unique topic to assoicate post with
        user: users.sample
    )
end

posts = Post.all #retrieves every post object from the db and stores it in variable called posts - returns array

100.times do
    Comment.create!(
        post: posts.sample, #array method to pick out random element, in this case a post object
        body: RandomData.random_paragraph
    )
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Topic.count} topics created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"