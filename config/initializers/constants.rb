module Flie
  module Os
    Y = :y
    CMDS = {
      AROFLIE: {
        name: :aroflie,
        access: Aro::Mancy::OS,
        gets: [
          :nothing,
        ]
      },
      CLEAR: {
        name: :clear,
        access: Aro::Mancy::O,
        gets: [
          :confirm,
        ]
      },
      CRS: {
        name: :crs,
        access: Aro::Mancy::S,
        gets: [
          :nothing
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

    # the display text for each GETS is
    # defined in localization files.
    # right now the values are getting set
    # in the db/seed file.
    GETS = {
      COMMAND: { # not used right now
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
      NOTHING: {
        name: :nothing,
        input_type: :nothing
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
