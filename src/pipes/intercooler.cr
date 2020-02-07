# Intercooler requests are to be handled like how rails handles application/js
# Example params from an intercooler request:
# ic-request: true
# ic-id: 1
# ic-target-id: device-2
# ic-current-url: /remote_credentials
#
# remove these and set the Accept header to "application/javascript"
class Intercooler < Amber::Pipe::Base
  def call(context)
    if context.request.params.has_key?("ic-request")
      Amber.logger.info("Changing accept header to application/javascript")
      context.request.headers["Accept"] = "application/javascript"
    end
    call_next(context)
    # if ic = context.request.params["ic-id"]
    #   context.request.params.delete "ic-id"
    # end
    # if ic = context.request.params["ic-target-id"]
    #   context.request.params.delete "ic-target-id"
    # end
    # if ic = context.request.params["ic-current-url"]
    #   context.request.params.delete "ic-current-url"
    # end
  end
end
