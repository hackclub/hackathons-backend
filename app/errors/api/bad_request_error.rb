class Api::BadRequestError < Api::Error
  def initialize(
    title: "Bad Request",
    detail: "you've done a whoopsie!",
    status: :bad_request,
    type: :bad_request_error
  )
    super
  end
end
