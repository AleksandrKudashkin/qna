shared_examples_for 'votable' do
  describe 'PATCH#vote_up' do
    context 'author of the subject' do
      before { sign_in(user) }

      it 'should not add new vote to subject, vote up' do
        vote_up_request.call
        expect { vote_up_request.call }.to_not change(subject.votes, :count)
      end
    end

    context 'other_user' do
      before { sign_in(other_user) }

      it 'should add new vote to subject, vote up' do
        expect { vote_up_request.call }.to change(subject.votes, :count).by(1)
      end

      it 'should not add new vote to subject if this user has already voted, vote up' do
        vote_up_request.call
        expect { vote_up_request.call }.to_not change(subject.votes, :count)
      end
    end
  end

  describe 'PATCH#vote_down' do
    context 'author of the subject' do
      before { sign_in(user) }

      it 'should not add new vote to subject, vote down' do
        vote_down_request.call
        expect { vote_down_request.call }.to_not change(subject.votes, :count)
      end
    end
    context 'other_user' do
      before { sign_in(other_user) }

      it 'should not add new vote to subject if this user has already voted, vote down' do
        vote_down_request.call
        expect { vote_down_request.call }.to_not change(subject.votes, :count)
      end

      it 'should add new vote to subject, vote down' do
        expect { vote_down_request.call }.to change(subject.votes, :count).by(1)
      end
    end
  end

  describe 'DELETE#cancel_vote' do
    before { sign_in(other_user) }

    it 'should delete vote from subject when already voted' do
      vote_up_request.call
      expect do
        cancel_vote_request.call
      end.to change(subject.votes, :count).by(-1)
    end
  end
end
