class Contact
  attr_accessor :phone_number, :person, :town

  def initialize(params)
    @phone_number = params[:phone_number]
    @person = params[:person]
    @town = params[:town]
  end

  def equal?(other)
    phone_number == other.phone_number && person == other.person
  end

  def not_equal?(other)
    phone_number == other.phone_number && person != other.person
  end

  def to_s
    "#{@person}: #{@phone_number} (#{@town})"
  end
end
