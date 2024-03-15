# frozen_string_literal: true

class User < ApplicationRecord
  # where the preferences are stored
  serialize :preferences, coder: JSON

  # where the preferences are described
  serialize :preferences_schema, coder: JSON

  # initialize record with empty objects
  before_create lambda {
                  self.preferences_schema ||= {}
                  self.preferences ||= {}
                }

  # or we could pass an argument with schema attribute name
  validates :preferences, by_schema: true

  # no real need to have it here, only for test purposes
  DEFAULT_SCHEMA = {
    age: {
      type: Numeric,
      required: true
    },
    nickname: {
      type: String,
      required: false
    },
    gender: {
      type: Array,
      options: %w[male female php],
      required: true,
      multiple: false
    },
    languages: {
      type: Array,
      options: %w[English Ukrainian Java],
      required: false,
      multiple: true
    }
  }.freeze
end
