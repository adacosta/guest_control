Amber::Server.configure do
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    # plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
    plug Intercooler.new
    plug Authenticate.new
  end

  pipeline :api do
    # plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CORS.new
  end

  # All static content will run these transformations
  pipeline :static do
    # plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :web do
    resources "access_windows", AccessWindowController
    resources "devices", DeviceController, only: [:index, :show, :edit, :update, :destroy]
    patch "devices/:id", DeviceController, :update
    resources "remote_credentials", RemoteCredentialsController
    post "/remote_credentials/:remote_credential_id/devices_fetch", DevicesFetchController, :create
    post "/devices/:device_id/actions", DeviceActionsController, :create

    resources "guests", GuestController
    get "/w/:slug", GuestDeviceController, :show
    get "/profile", UserController, :show
    get "/profile/edit", UserController, :edit
    patch "/profile", UserController, :update
    get "/signin", SessionController, :new
    post "/session", SessionController, :create
    get "/signout", SessionController, :delete
    get "/signup", RegistrationController, :new
    post "/registration", RegistrationController, :create
    get "/", HomeController, :index

    websocket "/devices", DevicesSocket
    websocket "/remote_credential_devices", RemoteCredentialDevicesSocket
  end

  routes :api do
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
  end
end
