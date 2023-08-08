class Location
  def initialize(city, province, country)
    @city = city
    @province = province
    @country = country
  end

  attr_reader :city, :province, :country

  # Listed in the order of significance.
  # The name "component" is pulled from USPS
  # https://pe.usps.com/text/pub28/28c2_012.htm#ep526349
  COMPONENTS = [:city, :province, :country]

  def component(compon)
    send(compon) if compon.in? COMPONENTS
  end

  def components
    [@city, @province, @country]
  end

  def most_significant_component
    # The "most significant component" represents the most specific location
    # attribute that is provided. This is similar to the concept of "most
    # significant bit". With a full location (all attributes provided), the most
    # significant component is the city.
    COMPONENTS.each do |compon|
      return compon if send(compon).present?
    end
  end

  def ==(other)
    components == other.components
  end

  def covers?(other)
    # Location A covers location B if location A is the more broad than location B.

    return false unless most_significant_component_value && other.most_significant_component_value
    return false if most_significant_component_value >= other.most_significant_component_value # Location A is more specific than location B.

    sig = other.most_significant_component_value
    COMPONENTS[sig..].all? do |compon|
      component(compon) == other.component(compon)
    end
  end

  def covers_or_equal?(other)
    self == other || covers?(other)
  end

  def covered_by?(other)
    other.covers?(self)
  end

  def covered_by_or_equal?(other)
    self == other || covered_by?(other)
  end

  def to_s
    components.compact.join(", ")
  end

  def to_formatted_s(format = nil)
    case format
    when :short
      (@country == "US") ? [city, province].compact.join(", ") : to_s
    else
      to_s
    end
  end

  alias_method :to_fs, :to_formatted_s

  protected

  # "Most Significant Component" value. Components with a higher significance
  # have a higher value. This is useful for comparing the significance of two
  # components.
  def most_significant_component_value
    COMPONENTS.reverse.index most_significant_component
  end
end
