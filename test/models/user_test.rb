# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'basic valid preferences' do
    user = User.new
    user.preferences_schema = User::DEFAULT_SCHEMA
    user.preferences = {
      age: 25,
      gender: ['male'],
      languages: %w[English Ukrainian]
    }

    assert user.valid?
  end

  test 'basic invalid preferences' do
    user = User.new
    user.preferences_schema = User::DEFAULT_SCHEMA
    user.preferences = {
      age: '25',
      gender: %w[male female],
      languages: []
    }

    refute user.valid?
  end

  test 'off-schema preferences' do
    user = User.new
    user.preferences_schema = User::DEFAULT_SCHEMA
    user.preferences = {
      children: ['Jimbo']
    }

    refute user.valid?
    assert_includes user.errors, 'preferences'
    assert_includes user.errors[:preferences], 'children is not allowed'
  end

  test 'schema update with preferences' do
    user = User.create(preferences_schema: User::DEFAULT_SCHEMA,
                       preferences: { age: 25, gender: ['male'], languages: %w[English Ukrainian] })

    user.update(
      preferences_schema: {
        children: {
          type: Array,
          multiple: true
        }
      },
      preferences: {
        children: ['Jimbo']
      }
    )

    assert user.valid?
  end

  test 'schema update without preferences' do
    user = User.create(preferences_schema: User::DEFAULT_SCHEMA,
                       preferences: { age: 25, gender: ['male'], languages: %w[English Ukrainian] })

    user.update(preferences_schema: {
                  children: {
                    type: Array,
                    multiple: true
                  }
                })

    refute user.valid?
    assert_includes user.errors, 'preferences'
    assert_includes user.errors[:preferences], 'age is not allowed'
    assert_includes user.errors[:preferences], 'gender is not allowed'
    assert_includes user.errors[:preferences], 'languages is not allowed'
  end
end
