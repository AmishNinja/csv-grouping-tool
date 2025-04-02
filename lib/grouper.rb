require_relative 'union_find'

# Groups Row objects by their matching types.
# 
# This is the "transform" class of the ETL pipeline
class Grouper
  attr_reader :rows, :matching_type, :contact_key_to_row

  # @param rows [Array<Row>] collection of rows to group
  # @param matching_type [Symbol] matching strategy: :email, :phone, or :email_or_phone
  def initialize(rows, matching_type)
    @matching_type = matching_type
    @rows = rows
    @contact_key_to_row = {}
  end

  # Groups each row into its appropriate disjoint set based on matching keys. 
  # Additionally, assign a unique group identifier to each set.
  # 
  # @return [void]
  def group
    rows.each { |row| process_row(row) }
    assign_group_uids(union_find.groups)
  end

  private

  # Memoized instance of UnionFind
  # 
  # @return [UnionFind]
  def union_find
    @union_find ||= UnionFind.new
  end

  # Ensures the row is tracked, then merges it into existing groups based on matching keys.
  #
  # @param row [Row]
  # @return [void]
  def process_row(row)
    ensure_row_registered(row)

    row.match_keys(matching_type).each { |key| record_or_merge(row, key) }
  end

  # Merges row into existing group or initializes it as a standalone group.
  # 
  # @param row [Row]
  # @param key [String] normalized email or phone
  # @return [void]
  def record_or_merge(row, key)
    if contact_key_to_row.key?(key)
      union_find.union(row, contact_key_to_row[key])
    else
      contact_key_to_row[key] = row
    end
  end

  # Ensure tracking of row in UnionFind instance even if it's standalone.
  # 
  # @param row [Row]
  # @return [void]
  def ensure_row_registered(row)
    union_find.find(row)
  end

  # Assign group's unique identifier to each row within each set.
  # 
  # @param groups [Array<Array<Row>>]
  # @return [void]
  def assign_group_uids(groups)
    groups.each_with_index do |group, idx|
      uid = "GROUP_#{idx + 1}"
      group.each { |row| row.group_id = uid }
    end
  end
end