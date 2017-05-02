class HastagService
  def initialize(params)
    @params  = params
    @errors  = []
    @results = nil
  end

  def errors?
    @errors.present?
  end

  def errors
    @errors
  end

  def results
    @results
  end

  def to_string
    if self.is_array
      @results = @params.join(",")
      true
    else
      @errors << "Can't format Hastag to string list. Source must be Array type!"
      false
    end

  end

  def to_array
    if self.is_string
      @results = @params.split(",").map{|tag| tag.remove("#")}
      true
    else
      @errors << "Can't format Hastag to array of string. Source must be Text type!"
      false
    end
  end

  def extract
    if self.is_string
      @results = @params.scan(/#[[:alnum:]]+/).map{|tag| tag.remove("#")}.flatten
      true
    else
      @errors << "Can't format Hastag to array of string. Source must be Text type!"
      false
    end

  end

  def is_array
    @params.is_a?(Array)
  end

  def is_string
    @params.is_a?(String)
  end

  def perform
  end
end