class CommentsForm < Reform::Form
  property :body, validates: { presence: true }
end
