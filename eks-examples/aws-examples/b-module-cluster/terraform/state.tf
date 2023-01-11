# It is possible to add workspace to the remote state
# so it gets the state of the backend of the corresponding workspace
data "terraform_remote_state" "vpc" {
	backend    = "s3"
	config = {
		bucket  = "terraform.huge.head.li.2023"
		key     = "${local.vpc-state-key}"
		region  = "us-east-1"
		encrypt = "true"
	}
}
