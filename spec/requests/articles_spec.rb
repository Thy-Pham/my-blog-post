require 'rails_helper'

describe 'Articles API', type: :request do
    # Global for every test
    let(:first_user) { FactoryBot.create(:user, email: "test1@com", password: "123456") }
    let(:second_user) { FactoryBot.create(:user, email: "test2@com", password: "456789") }
    
    describe 'GET /articles' do
        # Run this before every test inside describe
        before do
            FactoryBot.create(:article, title: 'Harry Potter', body: 'JK Rowling', status: "public", user_id: first_user.id)
            FactoryBot.create(:article, title: 'Fairy tail', body: 'Mark Hangula', status: "private", user_id: second_user.id)
        end
        it 'returns all articles' do
            get '/articles'
    
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body).size).to eq(2)
        end
    end

    describe 'POST /articles' do
        it 'create a new article' do
            expect {
                post '/articles', params: {
                    article: { title: 'Harry Potter', body: 'JK Rowling', status: "public"},
                    # query params
                    authentication_token: first_user.authentication_token
                }
            }.to change { Article.count }.from(0).to(1)
            expect(response).to have_http_status(:created)
        end
    end

    describe 'PUT /articles/:id' do
        let!(:article) { FactoryBot.create(:article, title: 'Harry Potter', body: 'JK Rowling', status: "public", user_id: first_user.id) }

        it 'update an article' do
            put "/articles/#{article.id}", params: {
                article: { title: 'Harry Potter 1'},
                authentication_token: first_user.authentication_token
            }
            response_body = JSON.parse(response.body)
            expect(response_body['title']).to eq('Harry Potter 1')
            expect(response).to have_http_status(:ok)
        end
    end

    describe 'DELETE /api/v1/books' do
        # Add ! means when the test first starts, factory get created
        let!(:article) { FactoryBot.create(:article, title: 'Harry Potter', body: 'JK Rowling', status: "public", user_id: first_user.id) }
        
        it 'delete an article' do
            expect {
                delete "/articles/#{article.id}", params: {
                authentication_token: first_user.authentication_token
            }
            }.to change { Article.count }.from(1).to(0)
            
            expect(response).to have_http_status(:no_content)
        end
    end
end
