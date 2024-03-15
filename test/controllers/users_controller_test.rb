# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should post valid update' do
    user = User.create(name: 'Jon Doe',
                       preferences: { color: 'blue' },
                       preferences_schema: { color: { type: String } })
    patch user_url(user, format: :json), params: { user: { preferences: { color: 'yellow' } } }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_nil json_response['errors']
    user.reload
    assert_equal 'yellow', user.preferences['color']
  end

  test 'should post invalid update' do
    user = User.create(name: 'Jane Doe',
                       preferences: { color: 'blue' },
                       preferences_schema: { color: { type: String } })

    patch user_url(user, format: :json), params: { user: { preferences: { age: 99 } } }
    json_response = JSON.parse(response.body)
    assert_response :unprocessable_entity
    assert json_response['errors'].present?
  end
end
