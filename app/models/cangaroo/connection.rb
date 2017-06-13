module Cangaroo
  class Connection < ActiveRecord::Base
    serialize :parameters

    validates :name, presence: true, uniqueness: true

    after_initialize :set_default_parameters

    def self.authenticate(key, token)
      where(key: key, token: token).first
    end

    private

    def set_default_parameters
      self.parameters ||= {}
    end
  end
end
