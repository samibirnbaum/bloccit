require "random_data" #requires a separate file of ruby code - often a class
15.times do
    Topic.create!(
        name: RandomData.random_sentence,
        description: RandomData.random_paragraph
    )
end

topics = Topic.all

20.times do
    SponsoredPost.create!(
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph, 
        price: RandomData.random_integer,
        topic_id: topics.sample.id
    )
end

50.times do
    Post.create!(
        title: RandomData.random_sentence, #use these methods on the class to create strings for our attributes
        body: RandomData.random_paragraph,
        topic: topics.sample #array method - picks out unique topic to assoicate post with
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
puts "#{Topic.count} topics created"
puts "#{Post.count} posts created"
puts "#{SponsoredPost.count} sponsored posts created"
puts "#{Comment.count} comments created"