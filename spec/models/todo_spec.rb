# typed: false
# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Todo) do
  describe "validations" do
    subject { build(:todo) }

    it { is_expected.to(validate_presence_of(:title)) }
    it { is_expected.to(validate_length_of(:title).is_at_least(1).is_at_most(255)) }
    # NOTE: position is auto-set by before_validation callback, so we test numericality only
    it { is_expected.to(validate_numericality_of(:position).only_integer.is_greater_than_or_equal_to(0)) }
  end

  describe "scopes" do
    let!(:active_todo) { create(:todo, :active, position: 2) }
    let!(:completed_todo) { create(:todo, :completed, position: 1) }

    describe ".ordered" do
      it "returns todos ordered by position ascending" do
        expect(described_class.ordered).to(eq([completed_todo, active_todo]))
      end
    end

    describe ".completed" do
      it "returns only completed todos" do
        expect(described_class.completed).to(eq([completed_todo]))
      end
    end

    describe ".active" do
      it "returns only active todos" do
        expect(described_class.active).to(eq([active_todo]))
      end
    end
  end

  describe "callbacks" do
    describe "#set_position" do
      context "when position is not set" do
        it "sets position to next available" do
          create(:todo, position: 5)
          todo = create(:todo, position: nil)
          expect(todo.position).to(eq(6))
        end
      end

      context "when no todos exist" do
        it "sets position to 1" do
          todo = create(:todo, position: nil)
          expect(todo.position).to(eq(1))
        end
      end

      context "when position is already set" do
        it "does not change the position" do
          todo = create(:todo, position: 10)
          expect(todo.position).to(eq(10))
        end
      end
    end
  end

  describe "#toggle!" do
    it "toggles completed from false to true" do
      todo = create(:todo, completed: false)
      todo.toggle!
      expect(todo.completed).to(be(true))
    end

    it "toggles completed from true to false" do
      todo = create(:todo, completed: true)
      todo.toggle!
      expect(todo.completed).to(be(false))
    end
  end
end
