# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SpaceStone::Derivatives::Processor do
  let(:manifest) do
    SpaceStone::Derivatives::Manifest::Original.new(parent_identifier: 1, original_filename: "hello", derivatives: [:hocr])
  end

  let(:process) { double(SpaceStone::Derivatives::Processes::Base, call: true) }
  let(:processor) { described_class.new(manifest: manifest, process: process) }
  let(:repository) { processor.repository }

  describe '#chain' do
    subject { processor.chain }

    it { is_expected.to be_a SpaceStone::Derivatives::Chain }
  end

  describe '#call' do
    let(:first_link) { double(SpaceStone::Derivatives::Types::BaseType) }
    let(:second_link) { double(SpaceStone::Derivatives::Types::BaseType) }
    let(:chain) { [first_link, second_link] }
    let(:processor) { described_class.new(manifest: manifest, process: process, chain: chain) }

    it 'iterates through the chain links' do
      processor.call
      expect(process).to have_received(:call).with(repository: repository, derivative: first_link)
      expect(process).to have_received(:call).with(repository: repository, derivative: second_link)
    end
  end

  describe '.call' do
    context 'with a defined process' do
      it "instantiates the processor and calls the processor" do
        expect_any_instance_of(described_class).to receive(:call)
        described_class.call(manifest: manifest, process: :pre_process)
      end
    end

    context 'with an undefined process' do
      it 'will raise a NotImplementedError' do
        expect { described_class.call(manifest: manifest, process: :no_such_process) }.to raise_exception NameError
      end
    end
  end
end
