RSpec::Matchers.define :be_memoized_as do |instance_variable_name|
  match do |value|
    instance.instance_variable_get(:"@#{instance_variable_name}") == value
  end

  failure_message do |value|
    "expected that #{value} would be memoized in @#{instance_variable_name} on #{instance}. " \
      "Instead, @#{instance_variable_name} contained " \
      "#{instance.instance_variable_get(:"@#{instance_variable_name}")}"
  end

  failure_message_when_negated do |relation|
    "expected that #{value} would not be memoized in @#{instance_variable_name} on #{instance}"
  end

  chain :on do |value|
    @instance = value
  end

  def instance
    @instance ||= subject
  end
end
