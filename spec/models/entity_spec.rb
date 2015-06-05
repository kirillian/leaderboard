require 'rails_helper'

describe Entity do
  describe "Class Methods" do
    subject { Entity }
    let(:row_number) { subject.row_number.to_s }
    let(:window_function) { subject.window_over_latest_score_desc.to_sql }

    describe ".with_rank" do
      it "is an ActiveRecord Relation" do
        expect(subject.with_rank).to be_a ActiveRecord::Relation
      end

      it "returns a window function aliased as rank" do
        expect(subject.with_rank).to contain_clause("#{row_number} OVER #{window_function} AS rank")
      end
    end

    describe ".window_over_latest_score_desc" do
      it "is an Arel Window Node" do
        expect(subject.window_over_latest_score_desc).to be_a Arel::Nodes::Window
      end

      it "returns a window clause over latest_score" do
        expect(subject.window_over_latest_score_desc).to contain_clause("(ORDER BY \"entities\".\"latest_score\" DESC)")
      end
    end

    describe ".row_number" do
      it "is an Arel Sql Literal" do
        expect(subject.row_number).to be_a Arel::Nodes::SqlLiteral
      end

      it "contains row_number()" do
        expect(subject.row_number).to contain_clause("row_number()")
      end
    end
  end
end
