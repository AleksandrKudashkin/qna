class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :short_title
  has_many :answers
  has_many :comments
  has_many :attachments

  def short_title
    object.title.truncate(10)
  end
end
