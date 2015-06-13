require 'rails_helper'

RSpec.describe Question, type: :model do

  describe Question do

    it { should validate_presence_of :title }
    it { should validate_presence_of :question_body }
    it { should validate_length_of(:title).is_at_least(5).is_at_most(150) }
    it { should validate_length_of(:question_body).is_at_most(3000) }
    
  end
end
