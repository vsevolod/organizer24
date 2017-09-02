FactoryGirl.define do
  factory :working_hour do
    week_day { Random.new.rand(1..6) }
    begin_hour { Random.new.rand(8..12).to_i }
    begin_minute { Random.new.rand(60).to_i }
    end_hour { Random.new.rand(17..24).to_i }
    end_minute { Random.new.rand(60).to_i }

    trait :now do
      week_day { Date.today.wday }
      begin_hour { Time.now.hour }
      begin_minute 00
      end_hour do
        simple_hour = 3.hour.since.hour
        simple_hour = 23 if simple_hour < begin_hour
        simple_hour
      end
      end_minute 59
    end

    trait :all_day do
      begin_hour 0
      begin_minute 0
      end_hour 23
      end_minute 59
    end
  end
end
