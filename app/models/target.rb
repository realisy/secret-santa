class Target < ActiveRecord::Base
  belongs_to :santa, class_name: "User", foreign_key: "santa_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :event

  # validates :event, uniqueness: { scope: :santa}

  class << self
    def assign_targets(event)
      @santas = event.users.to_ary
      @recipients = event.users.to_ary
      @santas.each do |santa|
          loop do
            rand_id = rand(@recipients.size)
            @recipient = @recipients[rand_id]
            break if santa != @recipient || @recipients.size <= 1
          end

          if santa == @recipient
            # If enters here, it means that we only have one pair (santa, recipient) remaining
            # both with the same user. If this happens, we will swap the recipient with anoter random Target.
            rand_id = rand(Target.where(event: event).count)
            target = Target.where(event: event)[rand_id]
            #
            temp_recipient = target.recipient
            target.recipient = @recipient
            @recipient = temp_recipient 
            target.save!
          end
          Target.create!(santa: santa, recipient: @recipient, event: event)
          @recipients = @recipients.reject {|recipient| recipient == @recipient}
      end
    end
  end

end