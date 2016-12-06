class QuestionsController < ApplicationController
  require 'net/http'
  require 'json'

  def call_api(params)
    puts uri = URI("http://rmatch.herokuapp.com/topics/start?rmatch=#{CGI::escape(params.to_json.to_s)}")
    response = uri.open.read
    JSON.parse(response)
  end


  def question
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
    case params[:name]
      when "Trump"
        @color = "#CE0000"
        @web_page = "https://www.donaldjtrump.com/"
        @bio = "Donald Trump forjó desde los años 80 un imperio empresarial orientado a la construcción de casinos, hoteles y viviendas de lujo que supo mantener pese a las dificultades financieras. Cobró con ello un considerable prestigio y popularidad como encarnación del self-made man norteamericano, a pesar de su carácter ególatra y sus dudosos escrúpulos. De ideología extremadamente conservadora, su constante presencia en la televisión y sus declaraciones fuera de tono lo convirtieron, a partir de 2005, en uno de los personajes más polémicos del país."
      when "Garry"
        @color = "#FFCC33"
        @web_page = "https://www.johnsonweld.com/"
        @bio = "Es un empresario estadounidense y exgobernador del estado de Nuevo México. Fue el 29o gobernador de Nuevo México de 1995 a 2003 por el Partido Republicano, y es conocido por su visión libertaria de bajos impuestos, y su participación regular en triatlones. En 2012 fue el candidato a la presidencia de los Estados Unidos por el Partido Libertario, y en 2016 fue escogido nuevamente como candidato a la presidencia de los Estados Unidos por el mismo partido."
      when "Hillary"
        @color = "#1B76FF"
        @web_page = "https://www.hillaryclinton.com/"
        @bio = "Abogada y política estadounidense, esposa del presidente demócrata Bill Clinton (1993 - 2001) y secretaria de Estado en la administración de Barack Obama. Hija de Hugh y Dorothy Rodham, cursó su educación primaria y secundaria en el Wellesley Collage de su ciudad natal, donde destacó tanto por su excelente historial académico como por su participación en la representación del alumnado."
      when "Stein"
        @color = "#99CC00"
        @web_page = "http://www.jill2016.com/about"
        @bio = "Encabeza el partido verde. Tiene estudios en medicina y está especializada en medicina interna, estudió en la Universidad de Harvard. Fue la candidata por el Partido Verde a la Presidencia de los Estados Unidos en las elecciones de 2012. Stein también fue candidata para Gobernadora de Massachusetts en las elecciones gubernamentales de dicho estado en 2002 y en 2010.Stein reside en Lexington, Massachusetts. Se graduó de la Universidad de Harvard en 1973 y la Escuela Médica de Harvard en 1979."
    end
    @parameters = [@name,@party + '.jpg',@photo, @color, @web_page, @bio]
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
