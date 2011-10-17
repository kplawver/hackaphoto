Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :tumblr, "xCgvYSBlH0eIgwKTRVpmXF8BN5TJJeEbjUiOoIQLyyuGqJolHK", "gWnVay3VNVM6y4qCPpzDVT27EYZL5WKCho91RpcDPVfxHRN3u4"
end