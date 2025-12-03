class TaxRate
  RATES = {
    "BC" => { gst: 0.05, pst: 0.07, hst: 0 },
    "AB" => { gst: 0.05, pst: 0,    hst: 0 },
    "SK" => { gst: 0.05, pst: 0.06, hst: 0 },
    "MB" => { gst: 0.05, pst: 0.07, hst: 0 },
    "ON" => { gst: 0,    pst: 0,    hst: 0.13 },
    "NB" => { gst: 0,    pst: 0,    hst: 0.15 },
    "NL" => { gst: 0,    pst: 0,    hst: 0.15 },
    "NS" => { gst: 0,    pst: 0,    hst: 0.15 },
    "PE" => { gst: 0.05, pst: 0.10, hst: 0 },
    "QC" => { gst: 0.05, pst: 0.09975, hst: 0 }
  }

  def self.for(province)
    RATES[province] || { gst: 0, pst: 0, hst: 0 }
  end
end
