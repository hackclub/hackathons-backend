class Api::Error < StandardError
  attr_reader :title, :detail, :status, :type

  def initialize(title: nil, detail: nil, status: nil, type: nil)
    @title = title
    @detail = detail
    @status = status
    @type = type
    super(title)
  end
end
