# Represents a single CSV row for grouping and export.
#
# Extracts normalized matching fields (email, phone) for grouping logic,
# and prepends a group unique identifier for output.
class Row
  EMAIL_KEYS = %w[Email Email1 Email2].freeze
  PHONE_KEYS = %w[Phone Phone1 Phone2].freeze

  attr_reader :raw_data
  attr_accessor :group_id

  # @param raw_data [CSV::Row] the original CSV row
  def initialize(raw_data)
    @raw_data = raw_data
  end

  # Returns normalized keys used for matching.
  #
  # @param type [Symbol] :email, :phone, or :email_or_phone
  # @return [Array<String>]
  def match_keys(type)
    case type
    when :phone
      phones
    when :email
      emails
    when :email_or_phone
      emails + phones
    end
  end

  # Prepends group identifier to the CSV row fields for output.
  #
  # @return [Array<String>]
  def to_csv_line
    [group_id] + raw_data.fields
  end

  private

  # @return [Array<String>] normalized emails
  def emails
    EMAIL_KEYS.map { |key| raw_data[key] }.compact.map(&:downcase)
  end

  # @return [Array<String>] normalized phone numbers
  def phones
    PHONE_KEYS.map { |key| raw_data[key] }.compact.map { |phone| normalize_phone_number(phone) }
  end

  # @param phone [String]
  # @return [String] stripped phone number
  def normalize_phone_number(phone)
    phone.gsub(/\D/, "")
  end
end
