module SortParams
  extend ActiveSupport::Concern

  def define_sort_params(sortable_columns, prefix_table = "")
    column = params[:sort] || "id"
    direction = params[:direction]

    column = sortable_columns[column.to_sym] || "#{prefix_table}id"
    direction = :asc unless %w[asc desc].include?(direction)

    # Add a deterministic secondary sort by id to ensure stable ordering
    # when the primary column has duplicate values
    Arel.sql("#{column} #{direction} NULLS LAST, #{prefix_table}id #{direction}")
  end
end
