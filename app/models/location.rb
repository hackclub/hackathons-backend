class Location
  def initialize(city, province, country_code)
    @city = city
    @province = province
    @country = country_code
  end

  attr_reader :city, :province, :country

  # Listed in the order of significance.
  # The name "component" is pulled from USPS
  # https://pe.usps.com/text/pub28/28c2_012.htm#ep526349
  COMPONENTS = [:city, :province, :country]

  def components
    [@city, @province, @country]
  end

  def country_name
    (ISO3166::Country[@country] || ISO3166::Country.find_country_by_any_name(@country))
      &.common_name
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

  COMPONENTS.each do |compon|
    define_method :"#{compon}_most_significant?" do
      most_significant_component == compon
    end
  end

  def ==(other)
    components == other.components
  end

  def covers?(other)
    # Location A covers location B if location A is the more broad than location B.

    return false unless most_significant_component_value && other.most_significant_component_value
    return false if most_significant_component_value >= other.most_significant_component_value # Location A is more specific than location B.

    # Loops from this object's most significant component to it's least
    # significant component.
    #   Example:
    #   - If MSC is city, then loop from          city -> province -> country
    #   - If MSC is province, then loop from      province -> country
    #   - If MSC is country, then loop through    country
    # For each iteration, check that each component is equal to the other
    # object's component.
    sig = COMPONENTS.index most_significant_component
    COMPONENTS[sig..].all? do |compon|
      send(compon) == other.send(compon)
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
    return country_name if country_most_significant? && country_name.present?

    components.compact.join(", ")
  end

  def to_formatted_s(format = nil)
    return to_s unless format == :short && @country == "US" && !country_most_significant?

    [city, province].compact.join(", ")
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
