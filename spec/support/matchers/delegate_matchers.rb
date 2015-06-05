# RSpec matcher to spec delegations.
# Forked from https://https://gist.github.com/joeytheman/0fe021821e4c62f552ce
# Added support for delegation to a different method_name
#
# Usage:
#
#     describe Post do
#       it { is_expected.to delegate(:name).to(:author).with_prefix } # post.author_name
#       it { is_expected.to delegate(:name).to(:author).with_prefix(:any) } # post.any_name
#       it { is_expected.to delegate(:author_name).to(:author).as(:name) } # post.author_name => author.name
#       it { is_expected.to delegate(:month).to(:created_at) }
#       it { is_expected.to delegate(:year).to(:created_at) }
#       it { is_expected.to delegate(:something).to(:'@instance_var') }
#     end

RSpec::Matchers.define :delegate do |method|
  match do |delegator|
    @method = method
    @method_on_receiver ||= [@prefix, @method].compact.join('_')
    @delegator = delegator

    if @receiver.to_s.first == '@'
      # Delegation to an instance variable
      old_value = @delegator.instance_variable_get(@receiver)
      begin
        @delegator.instance_variable_set(@receiver, receiver_double(method))
        @delegator.send(@method_on_receiver) == :called
      ensure
        @delegator.instance_variable_set(@receiver, old_value)
      end
    elsif @delegator.respond_to?(@receiver, true)
      unless [0, -1].include?(@delegator.method(@receiver).arity)
        fail "#{@delegator}'s' #{@receiver} method does not have zero or -1 arity (it expects parameters)"
      end
      allow(@delegator).to receive(@receiver).and_return(receiver_double(@method_on_receiver))
      @delegator.send(@method) == :called
    else
      fail "#{@delegator} does not respond to #{@receiver}"
    end
  end

  description do
    "delegate :#{@method} to its #{@receiver}#{@prefix ? ' with prefix' : ''}"
  end

  failure_message do
    "expected #{@delegator} to delegate :#{@method} to its #{@receiver}#{@prefix ? ' with prefix' : ''}" \
      "#{@different_method_on_receiver ? " as #{@method_on_receiver}" : ''}"
  end

  failure_message_when_negated do
    "expected #{@delegator} not to delegate :#{@method} to its #{@receiver}#{@prefix ? ' with prefix' : ''}" \
      "#{@different_method_on_receiver ? " as #{@method_on_receiver}" : ''}"
  end

  chain(:to) do |receiver|
    @receiver = receiver
  end

  chain(:with_prefix) do |prefix|
    @prefix = prefix || @receiver
  end

  chain(:as) do |as|
    @different_method_on_receiver = true
    @method_on_receiver = as
  end

  def receiver_double(method)
    double('receiver').tap do |receiver|
      allow(receiver).to receive(method).and_return(:called)
    end
  end
end
