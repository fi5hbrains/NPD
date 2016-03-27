json.array!(@ads) do |ad|
  json.extract! ad, :id, :name, :h_start, :h_end, :s_start
  json.url ad_url(ad, format: :json)
end
