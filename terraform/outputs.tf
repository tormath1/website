output "lb-ip" {
  description = "IP of the LB"
  value       = google_compute_global_address.static.address
}
