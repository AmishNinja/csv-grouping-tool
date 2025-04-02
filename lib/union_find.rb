# Disjoint set structure for grouping related objects.
#
# Used to identify groupings by linking objects via union-find logic.
class UnionFind
  # @return [Hash<Object, Object>] maps each object to its parent
  attr_reader :parent

  def initialize
    @parent = {}
  end

  # Finds the root of an object and shortens the path for future seeks (path compression).
  #
  # @param x [Object]
  # @return [Object]
  def find(x)
    parent[x] = x unless parent.key?(x)
    return x if parent[x] == x
    parent[x] = find(parent[x])
  end

  # Joins two objects into the same set.
  #
  # @param x [Object]
  # @param y [Object]
  def union(x, y)
    root_x = find(x)
    root_y = find(y)
    parent[root_y] = root_x unless root_x == root_y
  end

  # Groups objects by their root leader.
  #
  # @return [Array<Array<Object>>]
  def groups
    grouped = Hash.new { |h, k| h[k] = [] }

    parent.keys.each do |key|
      root = find(key)
      grouped[root] << key
    end

    grouped.values
  end
end
