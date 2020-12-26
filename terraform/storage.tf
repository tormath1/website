resource "google_storage_bucket" "static" {
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  location                    = "EUROPE-WEST3"
  name                        = "tormath1.fr"


  force_destroy = true

  versioning {
    enabled = true
  }

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  cors {
    origin          = ["https://tormath1.fr"]
    method          = ["GET", "HEAD"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.static.name
  role   = "roles/storage.legacyObjectReader"
  members = [
    "allUsers",
  ]
}
