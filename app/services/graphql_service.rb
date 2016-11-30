class GraphqlService

  def self.find_by_arguments(association, arguments)
    arguments.each do |key, value|
      next if key == 'limit'
      association = association.where(key => value)
    end
    # limit can't be more than 100.
    association.limit([arguments['limit'].to_i, 100].min)
  end

end
