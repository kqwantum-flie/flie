module Flie
  module Os
    CMDS = {
      AROFLIE: {
        name: :aroflie,
        access: Aro::Mancy::OS,
        gets: [
          :command
        ]
      },
      CRS: {
        name: :crs,
        access: Aro::Mancy::S,
        gets: [
          :command,
        ]
      },
      IN: {
        name: :in,
        access: Aro::Mancy::O,
        gets: [
          :email,
          :password,
        ]
      },
      OUT: {
        name: :out,
        access: Aro::Mancy::OS,
        gets: [
          :confirm,
        ]
      },
      PASSWD: {
        name: :passwd,
        access: Aro::Mancy::OS,
        gets: [
          :password,
          :new_password,
          :password_confirm,
        ]
      },
      UP: {
        name: :up,
        access: Aro::Mancy::O,
        gets: [
          :email,
          :password,
          :password_confirm,
        ]
      },
    }

    GETS = {
      COMMAND: {
        name: :command,
        input_type: :text
      },
      CONFIRM: {
        name: :confirm,
        input_type: :text
      },
      EMAIL: {
        name: :email,
        input_type: :email
      },
      NEW_PASSWORD: {
        name: :new_password,
        input_type: :password
      },
      PASSWORD: {
        name: :password,
        input_type: :password
      },
      PASSWORD_CONFIRMATION: {
        name: :password_confirm,
        input_type: :password
      },
    }
  end
end
