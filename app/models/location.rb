class Location
  def initialize(city, province, country)
    @city = city
    @province = province
    @country = country
  end

  attr_reader :city, :province, :country

  # The name "component" is pulled from USPS
  # https://pe.usps.com/text/pub28/28c2_012.htm#ep526349
  COMPONENTS_ORDERED_BY_SPECIFICITY = [:city, :province, :country]

  def component(compon)
    send(compon) if compon.in? COMPONENTS
  end

  def components
    [@city, @province, @country]
  end

  def sig_component
    # The significant component represents the most specific location attribute
    # that is provided (similar to sig figs in math).
    COMPONENTS.each do |compon|
      return compon if send(compon).present?
    end
  end

  def ==(other)
    components == other.components
  end

  def covers?(other)
    # Location A covers location B if location A is the more broad than location B.

    return false unless sig_component_value && other.send(:sig_component_value)
    return false if sig_component_value >= other.send(:sig_component_value) # Location A is more specific than location B.

    sig = other.send(:sig_component_value)
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

  private

  def sig_component_value
    COMPONENTS.reverse.index sig_component
  end
end
