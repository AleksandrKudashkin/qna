require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe Answer do
    it { should validate_presence_of :answer_body }
    it { should validate_presence_of :question_id }
    it { should validate_length_of(:answer_body).is_at_most(5000) }
    it { should belong_to :question }
  end
end
