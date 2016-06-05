class PostsForm < Reform::Form
  property :body, validates: { presence: true }

  collection :comments, form: CommentsForm,
    skip_if: :all_blank,
    populator: -> (collection:, index:, **) do
      if item = collection[index]
        item
      else
        collection.append(Comment.new)
      end
    end
end
