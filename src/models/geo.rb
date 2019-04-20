class Geo
  def self.bounding_box(latitudeInDegrees, longitudeInDegrees, halfSideInKm)
    lat = deg2rad(latitudeInDegrees)
    lon = deg2rad(longitudeInDegrees)
    halfSide = 1000*halfSideInKm

    # Radius of Earth at given latitude
    radius = WGS84EarthRadius(lat)
    # Radius of the parallel at given latitude
    pradius = radius*Math.cos(lat)

    latMin = lat - halfSide/radius
    latMax = lat + halfSide/radius
    lonMin = lon - halfSide/pradius
    lonMax = lon + halfSide/pradius

    return rad2deg(latMin), rad2deg(lonMin), rad2deg(latMax), rad2deg(lonMax)
  end

  def self.distance(lat_a, long_a, lat_b, long_b)
    rad_per_deg = Math::PI/180
    rkm = 6371
    rm = rkm * 1000

    dlat_rad = (lat_a - lat_b) * rad_per_deg
    dlon_rad = (long_a - long_b) * rad_per_deg

    lat_a_rad = lat_a * rad_per_deg
    long_a_rad = long_a * rad_per_deg
    lat_b_rad = lat_b * rad_per_deg
    long_b_rad = long_b * rad_per_deg
    
    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat_a_rad) * Math.cos(lat_b_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    (rm * c) / 1000
  end
  
  private

  # degrees to radians
  def self.deg2rad(degrees)
    return Math::PI*degrees/180.0
  end

  # radians to degrees
  def self.rad2deg(radians)
    return 180.0*radians/Math::PI
  end

  # Semi-axes of WGS-84 geoidal reference
  WGS84_a = 6378137.0  # Major semiaxis [m]
  WGS84_b = 6356752.3  # Minor semiaxis [m]

  # Earth radius at a given latitude, according to the WGS-84 ellipsoid [m]
  def self.WGS84EarthRadius(lat)
    # http://en.wikipedia.org/wiki/Earth_radius
    an = WGS84_a*WGS84_a * Math.cos(lat)
    bn = WGS84_b*WGS84_b * Math.sin(lat)
    ad = WGS84_a * Math.cos(lat)
    bd = WGS84_b * Math.sin(lat)
    return Math.sqrt( (an*an + bn*bn)/(ad*ad + bd*bd) )
  end
end
