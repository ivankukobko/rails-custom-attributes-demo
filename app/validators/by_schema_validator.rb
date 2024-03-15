# frozen_string_literal: true

# This is simple validator which for poor-man's JSON schema implementation
class BySchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # Possible variation: check for `require_schema: true|false` argument
    require_schema = true

    # Possible variation: check for `schema_attribute` argument if we don't want to guess
    attribute_schema = record["#{attribute}_schema"]

    # Yes, we need schema presence to validate input, let's be strict here for now
    record.errors.add(attribute, :schema_is_missing) and return if require_schema && !attribute_schema.present?

    # schema-related validations
    attribute_schema.each do |attr, settings|
      attr_value = value[attr]

      # 1. check for presence
      attr_missing = settings['presence'] == true && (!attr_value.present? ||
                                                      attr_value.is_a?(Array) && attr_value.empty?)
      record.errors.add(attribute, "#{attr} is missing") if attr_missing

      next unless attr_value.present?

      # 2. check for data type
      schema_type = settings['type'].safe_constantize || String
      type_match = attr_value.is_a?(schema_type)
      record.errors.add(attribute, "#{attr} type mismatch") unless type_match

      # 3. check single/multiple
      schema_multiple = settings['multiple']
      next unless schema_multiple.present? && attr_value.is_a?(Array) && schema_type.is_a?(Array)

      # - we don't allow multiple options and expect no more than 1 option present
      # - we allow multiple options and expect any amount of options
      # - we alredy checked for emptiness of Array attribute
      length_match = (!schema_multiple && attr_value.length <= 1) || (schema_multiple && attr_value.length >= 0)
      record.errors.add(attribute, "multiple #{attr} is not allowed") unless length_match

      # 4. check values for arrays
      # TODO
    end

    # off-schema related validations
    value.each_key do |attr|
      next if attribute_schema[attr].present?

      # 5. condemn off-schema attributes
      record.errors.add(attribute, "#{attr} is not allowed")
    end
  end
end
