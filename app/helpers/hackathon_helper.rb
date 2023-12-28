module HackathonHelper
  def hackathon_logo_url(hackathon)
    super(
      hackathon,
      v: hackathon.logo.updated_at.to_i
    )
  end
  
  def hackathon_banner_url(hackathon)
    super(
      hackathon,
      v: hackathon.banner.updated_at.to_i
    )
  end
end
