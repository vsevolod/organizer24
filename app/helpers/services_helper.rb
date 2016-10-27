# coding: utf-8
module ServicesHelper
  ## Возвращает массив: [category1, service11, service12, .. service1N, category2, service21, service22, .. service2N, ... serviceMN], разделенный на 3 части
  # def get_services(services)
  #  last_category = nil
  #  result = group_services.order(:category_id, :name).each_with_object([]) do |val, arr|
  #    category_name = val.category.try(:name) || 'Прочее'
  #    if last_category != category_name
  #      last_category = category_name
  #      arr.push(category_name)
  #    end
  #    arr.push(arr)
  #  end
  #  step = (result.size*1.0/3).ceil
  #  result.each_slice(step.zero? ? 1 : step).to_a
  # end
end
