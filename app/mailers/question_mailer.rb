class QuestionMailer < ApplicationMailer
  def daily_digest(user)
    @questions = Question.last24h
    mail(to: user.email, subject: 'The daily digest of QnA')
  end

  def new_answer(user, answer)
    @answer = answer
    @question = answer.question
    @user = user
    subject_insertion = @user.author_of?(@question) ? 'your question' : 'question you subscribed to'
    mail(to: user.email, subject: "A new answer for #{subject_insertion}")
  end
end
