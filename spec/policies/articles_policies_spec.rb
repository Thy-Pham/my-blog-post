require 'rails_helper'

describe ArticlePolicy do
    subject { described_class }

    let(:first_user) { FactoryBot.create(:user, email: "test1@com", password: "123456") }
    let(:second_user) { FactoryBot.create(:user, email: "test2@com", password: "456789") }
    let(:article) { FactoryBot.create(:article, title: 'Harry Potter', body: 'JK Rowling', status: "public", user_id: first_user.id) }

    context "for a visitor" do
        let(:user) { nil }

        permissions :new?, :create?, :edit?, :update?, :destroy? do
            it "denies access to article for whom the article does not belong" do
                expect(subject).not_to permit(user, article)
            end
        end
    end

    context "for user creating and editing own article" do
        permissions :new?, :create?, :edit?, :update?, :destroy? do
            it "grants access if article belongs to user" do
                expect(subject).to permit(first_user, article)
            end
        end

        permissions :update?, :destroy? do
            it "denies access if article does not belong to user" do
                expect(subject).not_to permit(second_user, article)
            end
        end
    end
end