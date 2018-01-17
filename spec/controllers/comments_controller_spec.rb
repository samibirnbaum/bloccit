require 'rails_helper'
include RandomData
include SessionsHelper

RSpec.describe CommentsController, type: :controller do
    let(:topic) {Topic.create!(name: RandomData.random_name, description: RandomData.random_paragraph, public: true)}
    let(:user) {User.create!(name: "Sami B", email: "s@gmail.com", password: "password", role: "member")}
    let(:post) {Post.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user, topic: topic)}
    let(:comment) {Comment.create!(body: RandomData.random_paragraph, post: post, user: user)}
    let(:other_user) {User.create!(name: "Mike B", email: "m@gmail.com", password: "password", role: "member")}

    context "guest" do
        describe "POST #create" do
            it "redirects guest to sign in page" do
                post :create, params: {post_id: post.id, comment: {body: RandomData.random_paragraph}}
                expect(response).to redirect_to(new_session_path)
            end
        end

        describe "DELETE #destroy" do
            it "redirects guest to sign in page" do
                delete :destroy, params: {post_id: post.id, id: comment.id}
                expect(response).to redirect_to(new_session_path)
            end
        end
    end
    
    
    
    
    
    
    
    context "member on own comment" do
        before do
            create_session(user)
        end
        describe "POST #create" do
            it "assigns correct values to @comment" do
                post :create,  post_id: post.id, comment: {body: RandomData.random_paragraph} #not taking in user who is associated with comment in the params (shallow params) will still add in create action before comment saved to database
                expect(assings(:comment).post_id).to eq(post.id)
                expect(assings(:comment).body).to eq(params[:comment][:body])
            end

            it "saves the comment increaing db by 1" do
                expect{ post :create, post_id: post.id, comment: {body: RandomData.random_sentence} }.to change(Comment,:count).by(1)
            end

            it "redirects user to show post" do
                post :create,  post_id: post.id, comment: {body: RandomData.random_paragraph}
                expect(response).to redirect_to(topic_post_path(topic.id, post.id))
            end
        end

        describe "DELETE #destroy" do
            it "deletes the comment from the db" do
                delete :destroy, params: {post_id: post.id, id: comment.id}
                count = Comment.where({id: comment.id}).count
                expect(count).to eq 0
            end

            it "redirects user" do
                delete :destroy, params: {post_id: post.id, id: comment.id}
                expect(response).to redirect_to(topic_post_path(topic.id, post.id))
            end
        end
    end
    
    
    
    
    
    
    
    
    context "member on someone elses comment" do
        before do
            create_session(other_user)
        end
        
        describe "POST create" do
            it "increases the number of comments by 1" do
              expect{ post :create, post_id: post.id, comment: {body: RandomData.random_sentence} }.to change(Comment,:count).by(1)
            end
      
            it "redirects to the post show view" do
              post :create, post_id: post.id, comment: {body: RandomData.random_sentence}
              expect(response).to redirect_to [topic, post]
            end
          end

        describe "DELETE #destroy" do
            it "redirects member to same page" do
                delete :destroy, params: {post_id: post.id, id: comment.id}
                expect(response).to redirect_to(topic_post_path(topic.id, post.id))
            end
        end
    end
    
    
    
    
    
    
    context "admin" do
        before do
            other_user.admin!
            create_session(other_user)
        end
        describe "POST #create" do
            it "assigns correct values to @comment" do
                post :create,  post_id: post.id, comment: {body: RandomData.random_paragraph} #not taking in user who is associated with comment in the params (shallow params) will still add in create action before comment saved to database
                expect(assings(:comment).post_id).to eq(post.id)
                expect(assings(:comment).body).to eq(params[:comment][:body])
            end

            it "saves the comment increaing db by 1" do
                expect{ post :create, post_id: post.id, comment: {body: RandomData.random_sentence} }.to change(Comment,:count).by(1)
            end

            it "redirects user to show post" do
                post :create,  post_id: post.id, comment: {body: RandomData.random_paragraph}
                expect(response).to redirect_to(topic_post_path(topic.id, post.id))
            end
        end

        describe "DELETE #destroy" do
            it "deletes the comment from the db" do
                delete :destroy, params: {post_id: post.id, id: comment.id}
                count = Comment.where({id: comment.id}).count
                expect(count).to eq 0
            end

            it "redirects user" do
                delete :destroy, params: {post_id: post.id, id: comment.id}
                expect(response).to redirect_to(topic_post_path(topic.id, post.id))
            end
        end
    end
end
