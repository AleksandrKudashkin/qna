module SearchesHelper
  def find_question(object)
    return object if object.instance_of?(Question)
    return object.question if object.instance_of?(Answer)

    return unless object.instance_of?(Comment)
    return object.commentable if object.commentable.instance_of?(Question)
    return object.commentable.question if object.commentable.instance_of?(Answer)
  end
end
