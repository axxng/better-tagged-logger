module TaggedLogger
  extend ActiveSupport::Concern

  def log_message(level, message = nil, info = {})
    log_message_with_class(level, message, info, class_name)
  end

  def log_message_with_alert_tag(level, message = nil, info = {})
    log_message_with_class(level, "[ALERT-START] #{message} [ALERT-END]", info, class_name)
  end

  private

  def class_name
    [Class, Module].include?(self.class) ? self : self.class
  end

  def log_message_with_class(level, message, info = {}, klass = self)
    prefixed_message = "[class=#{klass}]"
    prefixed_message << info[:tag].to_s if info[:tag].present?
    prefixed_message << " #{message} #{log_format(info.except(:exception, :tag))}"
    prefixed_message << add_exception_details(info[:exception])
    Rails.logger.send(level, prefixed_message)
  end

  def log_format(info_hash)
    info_hash.map { |k, v| "#{k}=#{v}" }
             .join(', ')
  end

  def add_exception_details(exception)
    return '' if exception.nil?

    exception_message = "---Cause: #{exception.message} ---ExceptionClass: #{exception.class.name}"
    exception_message << " #{exception.backtrace}" if exception.backtrace
    exception_message
  end
end
