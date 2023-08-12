# app/services/money_formatter_service.rb
class MoneyFormatterService
  class MoneyFormatter
    def initialize(micro_dollars)
      @micro_dollars = micro_dollars
    end

    def dollars
      @micro_dollars / 1000000
    end

    def cents
      (@micro_dollars / 10000) % 100
    end

    def to_s
      if @micro_dollars < 0
        "$#{dollars.abs}.#{cents.to_s.rjust(2, '0')}"
      else
        "$#{dollars}.#{cents.to_s.rjust(2, '0')}"
      end
    end

    def for_notification
      if @micro_dollars < 0
        "ask for #{self.to_s} to take the shift"
      elsif @micro_dollars == 0
        "offer to work the shift for free"
      else
        "offer #{self.to_s} to get the shift"
      end
    end
  end
end
