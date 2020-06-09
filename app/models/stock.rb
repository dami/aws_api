class Stock < ApplicationRecord
    validates :name, {length: {in: 1..8}}
    validates :amount, {format: { with: /\A\d+\z/}}
end
