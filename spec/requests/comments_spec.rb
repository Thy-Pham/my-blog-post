require 'rails_helper'

describe 'Comments API', type: :request do
    # Global for every test
    let(:first_user) { FactoryBot.create(:user, email: "test1@com", password: "123456") }
    let(:article) { FactoryBot.create(:article, title: 'Harry Potter', body: 'JK Rowling', status: "public", user_id: first_user.id) }
    
    describe 'GET /articles/:article_id/comments' do
        # Run this before every test inside describe
        before do
            FactoryBot.create(:comment, commenter: 'Thy Pham', body: 'Great article!', status: "public", article_id: article.id)
            FactoryBot.create(:comment, commenter: 'Halley Join', body: 'Not bad', status: "private", article_id: article.id)
        end

        it 'returns all articles' do
            get "/articles/#{article.id}/comments"
    
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body).size).to eq(2)
        end
    end

    describe 'POST /articles/:article_id/comments' do
        it 'create a new comment' do
            expect {
                post "/articles/#{article.id}/comments", params: {
                    comment: { commenter: 'Thy Pham', body: 'Great article!', status: "public"}
                }
            }.to change { Article.count }.from(0).to(1)
            expect(response).to have_http_status(:created)
        end
    end

    describe 'DELETE /articles/:article_id/comments/:id' do
        let!(:comment) { FactoryBot.create(:comment, commenter: 'Thy Pham', body: 'Great article!', status: "public", article_id: article.id) }


        it 'delete an article' do
            expect {
                delete "/articles/#{article.id}/comments/#{comment.id}"
            }.to change { Comment.count }.from(1).to(0)
            
            expect(response).to have_http_status(:no_content)
        end
    end
end

