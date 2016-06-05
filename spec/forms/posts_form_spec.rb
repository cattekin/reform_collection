require 'rails_helper'

RSpec.describe PostsForm, type: :model do

  describe 'validations' do
    subject(:post_form) { PostsForm.new(Post.new) }

    specify 'for body' do
      expect(post_form).to validate_presence_of(:body)
    end
  end

  describe '#save' do
    subject(:post_form) { PostsForm.new(Post.new) }

    let(:saving_the_form) do
      -> { post_form.save }
    end

    let(:comment_params) do
      { body: 'Test' }
    end
    let(:post_params) do
      {
        body: 'Crown & Anchor',
        comments: [comment_params]
      }
    end

    context 'when form values are valid' do

      it 'creates a new post' do
        post_form.validate(post_params)
        expect(saving_the_form).to change { Post.count }.by(1)
        expect(post_form.model.body).to eq post_params.fetch :body
      end

      it 'creates an associated comment' do
        post_form.validate(post_params)
        expect(saving_the_form).to change { Comment.count }.by(1)
        expect(post_form.model.comments.first.body).to eq comment_params.fetch :body
      end
    end

    context 'when form values are invalid' do
      it 'does not create a new post' do
        expect(post_form.validate({})).to eq false
      end
    end

    context 'when comment already exists' do
      let(:post) { Post.create(body: 'text to replace') }
      let(:comment) { post.comments.create(body: 'text to replace') }

      let(:comment_params) do
        {
          body: 'text to insert',
          comment_id: comment.id
        }
      end
      let(:post_params) do
        {
          body: 'text to insert',
          comments: [comment_params]
        }
      end

      subject(:post_form) { PostsForm.new(post) }

      it 'updates existing post and comment' do
        post_form.validate(post_params)
        expect(saving_the_form).to_not change { Post.count }
        expect(saving_the_form).to_not change { Comment.count }
        expect(post_form.model.body).to eq post_params.fetch :body
        expect(post_form.model.reload.comments.first.body).to eq comment_params.fetch :body
      end
    end
  end
end
