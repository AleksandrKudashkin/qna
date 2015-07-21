require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe Answer do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
    it { should validate_presence_of :user_id }
    it { should validate_length_of(:body).is_at_most(5000) }
    it { should belong_to :question }
    it { should belong_to :user }
  end
end
