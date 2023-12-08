# frozen_string_literal: true

# mymailer
class MyMailer < ApplicationMailer
  def welcome_email
    @task = params[:task]
    @user = params[:user]
    mail(to: @user.email, from: 'task management', task: @task, subject: 'Welcome to My Awesome Site')
  end

  def task_updated
    @task = params[:task]
    @user = params[:user]
    mail(to: @user.email, from: 'task management', task: @task, subject: 'Your task is updated')
  end

  def comments_on_task
    @task = params[:task]
    @user = params[:user]
    @comment = params[:comment]
    mail(to: @user.email, from: 'task management', task: @task, comment: @comment,
         subject: 'user commented on your task')
  end

  def send_mail_on_due_date
    @task = params[:task]
    @user = params[:user]
    mail(to: @user.email, from: 'task management', task: @task, subject: 'today your duedate')
  end
end
