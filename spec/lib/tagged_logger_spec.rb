require 'rails_helper'

class DummyClass
  # DummyClass for this spec

  def test_logging(log_level, message, exception, tag)
    log_message(log_level, message, { exception: exception, tag: tag })
  end

  def self.test_logging(log_level, message, exception, tag)
    log_message(log_level, message, { exception: exception, tag: tag })
  end

  def test_logging_with_alert(log_level, message, exception, tag)
    log_message_with_alert_tag(log_level, message, { exception: exception, tag: tag })
  end

  def self.test_logging_with_alert(log_level, message, exception, tag)
    log_message_with_alert_tag(log_level, message, { exception: exception, tag: tag })
  end
end

RSpec.describe TaggedLogger do
  let(:dummy_class) { DummyClass.new }
  let(:test_message) { 'test message' }

  describe '#log_message' do
    let(:expected_message) { "[class=#{DummyClass}] #{test_message} " }

    [:debug, :info, :warn, :error, :fatal, :unknown].each do |log_level|
      it "log level #{log_level} for instance methods" do
        dummy_class.test_logging(log_level, test_message, nil, nil)
        expect(Rails.logger).to have_received(log_level).with(expected_message)
      end

      it "log level #{log_level} for class methods" do
        DummyClass.test_logging(log_level, test_message, nil, nil)
        expect(Rails.logger).to have_received(log_level).with(expected_message)
      end
    end

    context 'with exceptions' do
      let(:test_exception_message) { 'test exception message' }
      let(:exception) { Exception.new(test_exception_message) }
      let(:expected_message) { "[class=#{DummyClass}] #{test_message} ---Cause: #{test_exception_message} ---ExceptionClass: Exception" }

      [:debug, :info, :warn, :error, :fatal, :unknown].each do |log_level|
        it log_level.to_s do
          dummy_class.test_logging(log_level, test_message, exception, nil)
          expect(Rails.logger).to have_received(log_level).with(expected_message)
        end
      end
    end

    context 'with tags' do
      let(:tag) { '[TEST_TAG]' }
      let(:expected_message) { "[class=#{DummyClass}]#{tag} #{test_message} " }

      [:debug, :info, :warn, :error, :fatal, :unknown].each do |log_level|
        it log_level.to_s do
          dummy_class.test_logging(log_level, test_message, nil, tag)
          expect(Rails.logger).to have_received(log_level).with(expected_message)
        end
      end
    end
  end

  describe '#log_message_with_alert_tag' do
    let(:expected_message) { "[class=#{DummyClass}] [ALERT-START] #{test_message} [ALERT-END] " }

    [:debug, :info, :warn, :error, :fatal, :unknown].each do |log_level|
      it "log level #{log_level} for instance methods" do
        dummy_class.test_logging_with_alert(log_level, test_message, nil, nil)
        expect(Rails.logger).to have_received(log_level).with(expected_message)
      end

      it "log level #{log_level} for class methods" do
        DummyClass.test_logging_with_alert(log_level, test_message, nil, nil)
        expect(Rails.logger).to have_received(log_level).with(expected_message)
      end
    end

    context 'with exceptions' do
      let(:test_exception_message) { 'test exception message' }
      let(:exception) { Exception.new(test_exception_message) }
      let(:expected_message) { "[class=#{DummyClass}] [ALERT-START] #{test_message} [ALERT-END] ---Cause: #{test_exception_message} ---ExceptionClass: Exception" }

      [:debug, :info, :warn, :error, :fatal, :unknown].each do |log_level|
        it log_level.to_s do
          dummy_class.test_logging_with_alert(log_level, test_message, exception, nil)
          expect(Rails.logger).to have_received(log_level).with(expected_message)
        end
      end

      context 'custom exceptions' do
        let(:exception) { Exceptions::Events::EventClassNameError.new(test_exception_message) }
        let(:expected_message) { "[class=#{DummyClass}] [ALERT-START] #{test_message} [ALERT-END] ---Cause: #{test_exception_message} ---ExceptionClass: Exceptions::Events::EventClassNameError" }

        [:debug, :info, :warn, :error, :fatal, :unknown].each do |log_level|
          it log_level.to_s do
            dummy_class.test_logging_with_alert(log_level, test_message, exception, nil)
            expect(Rails.logger).to have_received(log_level).with(expected_message)
          end
        end
      end
    end

    context 'with tags' do
      let(:tag) { '[TEST_TAG]' }
      let(:expected_message) { "[class=#{DummyClass}]#{tag} [ALERT-START] #{test_message} [ALERT-END] " }

      [:debug, :info, :warn, :error, :fatal, :unknown].each do |log_level|
        it log_level.to_s do
          dummy_class.test_logging_with_alert(log_level, test_message, nil, tag)
          expect(Rails.logger).to have_received(log_level).with(expected_message)
        end
      end
    end
  end
end
