def extract_relation_string(relation)
  case
  when relation.is_a?(Arel::Nodes::SqlLiteral)
    relation.to_s
  when relation.is_a?(Class)
    nil
  else
    relation.to_sql
  end
end

RSpec::Matchers.define :contains_where_clause do |clause|
  match do |relation|
    extract_relation_string(relation) =~ /WHERE .*?#{Regexp.escape(clause)}/
  end

  failure_message do |relation|
    "expected that WHERE clause in '#{relation.to_sql}' would contain #{clause}"
  end

  failure_message_when_negated do |relation|
    "expected that WHERE clause in '#{relation.to_sql}' would not contain #{clause}"
  end
end

RSpec::Matchers.define :contain_clause do |clause|
  match do |relation|
    extract_relation_string(relation) =~ /#{Regexp.escape(clause)}/
  end

  failure_message do |relation|
    "expected that '#{relation.to_sql}' would contain #{clause}"
  end

  failure_message_when_negated do |relation|
    "expected that '#{relation.to_sql}' would not contain #{clause}"
  end
end
