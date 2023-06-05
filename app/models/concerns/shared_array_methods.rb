module SharedArrayMethods
  def get_data_for_array(array = [])
    arrayWithData = []
    array.each do |model|
      arrayWithData.push(model.data)
    end
    return arrayWithData
  end
end
