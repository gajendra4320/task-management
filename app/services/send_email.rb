class SendEmail
  def initialize(task, user)
    @task = task
    @user = user
  end

  def welcome_email
    @task = params[:task]
    @user = params[:user]
    mail(to: @user.email, from: 'task management', task: @task, subject: 'Welcome to My Awesome Site')
  end

end
