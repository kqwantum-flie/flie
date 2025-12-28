module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :flie_o

    def connect
      set_flie_o
    end

    private

    def set_flie_o
      if session = Session.find_by(id: cookies.signed[:session_id])
        self.flie_o = session.user.you.flie_o
      else
        you = You.find_by(user: nil)
        if you.nil?
          self.flie_o = FlieO.create
          you = self.flie_o.you
        end
        self.flie_o = you.flie_o
      end
    end
  end
end
