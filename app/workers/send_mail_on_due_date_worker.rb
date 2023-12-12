class SendMailOnDueDateWorker
  include Sidekiq::Worker
  def perform
    @task = Task.find_by(due_date: Date.today)
    @user = User.find_by_id(@task.user_id)
    MyMailer.with(task: @task, user: @user).send_mail_on_due_date.deliver_now
  end
end
