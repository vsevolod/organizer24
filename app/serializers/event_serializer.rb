class EventSerializer < ActiveModel::Serializer

  attributes :title, :type, :starts_at, :ends_at, :editable, :deletable

  def title
    object.services.map(&:name).join('<br/>')
  end

  def type
    'info'
  end

  def starts_at
    object.start.iso8601
  end

  def ends_at
    object._end.iso8601
  end

  def editable
    false
  end

  def deletable
    false
  end

end
