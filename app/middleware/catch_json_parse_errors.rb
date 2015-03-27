class CatchJsonParseErrors
  def initialize app
    @app = app
  end

  def call env
    begin
      @app.call(env)
    rescue ActionDispatch::ParamsParser::ParseError => exception
      content_type_is_json?(env) ? build_response(exception) : raise(exception)
    end
  end

  private

  def content_type_is_json? env
    env['CONTENT_TYPE'] =~ /application\/json/
  end

  def error_message exception
    "Payload data is not valid JSON."
  end

  def build_response exception
    [ 400, { "Content-Type" => "application/json" }, [ {success: false, error_code: 3000, error_msg: "Payload data is not valid JSON."}.to_json ] ]
  end

end