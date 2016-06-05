require 'rails_helper'

RSpec.describe CommentsForm, type: :model do
  subject(:comment_form) { CommentsForm.new(Comment.new) }

  describe '#save' do
    let(:saving_the_form) do
      -> { comment_form.save }
    end

    context 'when form values are valid' do
      let(:comment_params) do
        { body: 'Test' }
      end

      it 'creates a new comment' do
        comment_form.validate(comment_params)
        expect(saving_the_form).to change { Comment.count }.by(1)

        expect(comment_form.model.body).to eq comment_params.fetch :body
      end
    end

    context 'when form values are invalid' do
      it 'does not return true' do
        expect(comment_form.validate({})).to eq false
      end
    end
  end
end
