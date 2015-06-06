require 'rails_helper'

describe API::APIController do
  describe 'Singleton Methods' do
    subject { API::APIController.new }

    describe '#method_missing' do
      context 'method name matches render_xxx' do
        it 'calls render status: xxx, nothing true' do
          expect(subject).to receive(:render).with(status: :status, nothing: true)
          subject.send(:method_missing, :render_status)
        end
      end

      context 'method name DOES NOT match render_xxx' do
        it 'raises a NoMethodError' do
          expect { subject.send(:method_missing, :non_existent_method) }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
