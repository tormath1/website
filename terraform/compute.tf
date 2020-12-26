resource "google_compute_backend_bucket" "static-backend" {
  name        = "static-backend"
  description = "Terraform managed"
  bucket_name = google_storage_bucket.static.name
  enable_cdn  = true
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "tormath1-cert"

  managed {
    domains = [
      "tormath1.fr."
    ]
  }
}

resource "google_compute_target_https_proxy" "static" {
  name             = "static-proxy"
  url_map          = google_compute_url_map.static.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_url_map" "static" {
  name            = "static-url-map"
  description     = "Terraform managed"
  default_service = google_compute_backend_bucket.static-backend.id

  host_rule {
    hosts        = ["tormath1.fr"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.static-backend.id
  }
}

resource "google_compute_global_address" "static" {
  name = "static-address"
}

resource "google_compute_global_forwarding_rule" "default" {
  name = "static-lb"

  target     = google_compute_target_https_proxy.static.id
  port_range = "443"
  ip_address = google_compute_global_address.static.address
}

resource "google_compute_target_http_proxy" "http" {
  name    = "static-proxy-http"
  url_map = google_compute_url_map.redirect.id
}

resource "google_compute_global_forwarding_rule" "redirect" {
  name = "static-lb-http"

  target     = google_compute_target_http_proxy.http.id
  port_range = "80"
  ip_address = google_compute_global_address.static.address
}

resource "google_compute_url_map" "redirect" {
  name        = "static-url-map-redirect"
  description = "Terraform managed"

  default_url_redirect {
    https_redirect = true
    strip_query = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}
