provider "google" {
  credentials = file("./credentials.json")
  project     = var.project
  region      = "europe-west2"
}

terraform {
  backend "gcs" {
    bucket      = "personal-remote-state"
    credentials = "./credentials.json"
  }
}

variable "project" {
  type        = string
  description = "ID of the project"
}
