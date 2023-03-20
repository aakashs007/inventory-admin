class ApiError < StandardError
  attr_reader :status, :message

  def initialize(message, status)
    @message = message
    @status = status
    super(message)
  end
end