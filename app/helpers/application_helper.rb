module ApplicationHelper
  # Mirror of time_ago_in_words except for durations longer than 30 days which
  # will remain formatting in number of days instead of months or years.
  # For example, "63 days ago" instead of "2 months ago"
  def time_ago_in_words_days_max(from_time, options = {})
    distance_of_time_in_words_days_max(from_time, Time.now, options)
  end

  # Mirror of distance_of_time_in_words except for durations longer than 30
  # days which will remain formatting in number of days instead of months or
  # years.
  def distance_of_time_in_words_days_max(from_time, to_time = 0, options = {})
    options = {
      scope: :'datetime.distance_in_words'
    }.merge!(options)
  
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    from_time, to_time = to_time, from_time if from_time > to_time
    distance_in_minutes = ((to_time - from_time)/60.0).round
    distance_in_seconds = (to_time - from_time).round
  
    I18n.with_options :locale => options[:locale], :scope => options[:scope] do |locale|
      case distance_in_minutes
        when 0..1
          return distance_in_minutes == 0 ?
                 locale.t(:less_than_x_minutes, :count => 1) :
                 locale.t(:x_minutes, :count => distance_in_minutes) unless options[:include_seconds]
  
          case distance_in_seconds
            when 0..4   then locale.t :less_than_x_seconds, :count => 5
            when 5..9   then locale.t :less_than_x_seconds, :count => 10
            when 10..19 then locale.t :less_than_x_seconds, :count => 20
            when 20..39 then locale.t :half_a_minute
            when 40..59 then locale.t :less_than_x_minutes, :count => 1
            else             locale.t :x_minutes,           :count => 1
          end
  
        when 2...45           then locale.t :x_minutes,      :count => distance_in_minutes
        when 45...90          then locale.t :about_x_hours,  :count => 1
        # 90 mins up to 24 hours
        when 90...1440        then locale.t :about_x_hours,  :count => (distance_in_minutes.to_f / 60.0).round
        # 24 hours up to 42 hours
        when 1440...2520      then locale.t :x_days,         :count => 1
        # 42 hours up to 30 days
        else locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
      end
    end
  end
end
