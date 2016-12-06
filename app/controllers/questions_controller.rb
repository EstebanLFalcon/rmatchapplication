class QuestionsController < ApplicationController
  require 'net/http'
  require 'json'

  def call_api(params)
    puts uri = URI("http://rmatch.herokuapp.com/topics/start?rmatch=#{CGI::escape(params.to_json.to_s)}")
    response = uri.open.read
    JSON.parse(response)
  end


  def question
    # uri = URI('http://rmatch.herokuapp.com/topics/start?rmatch=')
    # params = {:rmatch => {:topic_name => 'Politk', :session_data => [[],[],[]]}}
    # uri.query = URI.encode_www_form(params)
    # response = Net::HTTP.get(uri)
    params = {:topic_name => 'Politk', :session_data => [[],[],[]]}
    data = call_api params

    if(data['Type'] == 'question')
      @id = data['response'][0]['id']
      @question = data['response'][0]['question']
      @answers = data['response'][0]['answers']
      @session_data = data['session_data'].to_s
      @parameters = [@id,@question,@answers, @session_data]

    else

    end

    @parameters
  end

  def answer
    @name = params[:name]
    @party = params[:party].to_s.downcase
    @photo = params[:photo]

    @parameters = [@name,@party + '.jpg',@photo]
  end

  def renew_question
    answer = params[:answer]
    importance = params[:importance]
    id = params[:id]
    session = params[:session_data]

    params = {:topic_name => 'Politk', :question_id => id, :answer_input => answer,
              :importance => importance, :session_data => !(session ==  "[[],[],[]]")? JSON.parse(session) : [[],[],[]]}
    data = call_api params

    if(data['Type'] == 'question')
      @id = data['response'][0]['id']
      @question = data['response'][0]['question']
      @answers = data['response'][0]['answers']
      @session_data = data['session_data'].to_s
      @parameters = [@id,@question,@answers, @session_data]

    else
      @best_match = data['response']['Best_match']
      redirect_to action: 'answer', @answer_params => @best_match
      return
    end
    render action: 'question', @parameters => @parameters
  end
end
