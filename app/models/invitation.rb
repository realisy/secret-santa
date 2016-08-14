  class Invitation < ActiveRecord::Base
    belongs_to :user
    belongs_to :event

    def email_body
      "Hi!<br><br>

        #{user.name} (#{user.email}) invited you to participate in a wonderful Secret Santa!<br>

        If you want to accept the invitation, use the link below: <br>

        <a href='http://localhost:3000/accept_invite/#{invitation_code}'>Invitation Link</a><br>

        Thanks!<br>

      "
    end
  end
