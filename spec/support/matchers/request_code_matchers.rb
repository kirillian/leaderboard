RSpec::Matchers.define :be_status do |status, message = nil|
  match do |_response|
    assert_response status, message
  end
end
