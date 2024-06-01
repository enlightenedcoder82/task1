terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.27.0"
    }
  }
}

provider "google" {
  # Configuration options
  project     = var.Malgus[0]
  region      = var.Malgus[1]
  zone        = var.Malgus[2]
  credentials = var.Malgus[3]
}
 
#Variables
variable "Malgus" {
  type = list(string)
  description = "Grouping all the variables"
  default =  ["project-armaggaden-may11","us-east1",
  "us-east1-b","project-armaggaden-may11-2cff6047c441.json","US",
  "https://storage.googleapis.com/"] 
}
#Create a bucket
resource "google_storage_bucket" "malgus_order66" {
  name          = "${var.Malgus[0]}-malgus_order66"
  location      = var.Malgus[4]
  force_destroy = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

    uniform_bucket_level_access = false
}
#Make the bucket public
resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.malgus_order66.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_iam_binding" "public_access" {
  bucket = google_storage_bucket.malgus_order66.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = google_storage_bucket.malgus_order66.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}



#Output the URL
output "bucket_url" {
  value = "${var.Malgus[5]}${google_storage_bucket.malgus_order66.name}/index.html"
}





