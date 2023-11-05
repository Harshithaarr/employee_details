class Employee < ApplicationRecord
  validates :name, presence: true
  validates :age, numericality: { only_integer: true }
  validates :role, presence: true
  validates :band, inclusion: {in: %w(L1, L2, L3)}
end
