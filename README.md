# better-tagged-logger

This is an **approach** to how we can enhance logging in our Rails app to give us log output like these in single lines:

* [class=DummyClass] test message
* [class=DummyClass] test message ---Cause: test exception message ---ExceptionClass: Exception
* [class=DummyClass][test_tag] test message
* [class=DummyClass][test_tag] test message ---Cause: test exception message ---ExceptionClass: Exceptions::TestException

We may also use this in conjunction with `lograge` to output all request information in one line.

## Usage

See `DummyClass` in `spec/lib/tagged_logger_spec.rb`.

## Known issues

* `class=Object` when used in `.rake` files
