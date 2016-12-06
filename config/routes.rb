Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#index'
  scope path: '/', controller: :questions do
    get 'question' => :question
    # get 'question' => :question
    post 'question' => :renew_question
    get 'answer' => :answer
  end
end
