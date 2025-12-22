at_exit do
  Dir.chdir(Flie::Os::AROFLIE_PATH) do
    # todo: this should work
    # Aos::Fpx::Server.stop
    Flie::Os.system_pxy(:"fpx stop")
  end
end