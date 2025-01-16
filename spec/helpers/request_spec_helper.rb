module RequestSpecHelper

  class << self
    def api_v1_path
      "/api/v1"
    end

    def application_json
      "application/json"
    end
  end

  def json_response
    expect(response).not_to be_nil
    expect(response.body).not_to be_nil

    JSON.parse(response.body, symbolize_names: true)
  end

  def response_to_json(response)
    expect(response).not_to be_nil
    expect(response.body).not_to be_nil

    JSON.parse(response.body, symbolize_names: true)
  end
end
