class Phone
  attr_accessor :number, :person, :town

  def initialize(params)
    @number = params[:number]
    @person = params[:person]
    @town = params[:town]
  end

  def to_s
    "#{@person}: #{@number} (#{@town})"
  end
end
