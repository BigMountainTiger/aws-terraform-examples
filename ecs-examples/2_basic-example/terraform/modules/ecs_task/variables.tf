variable "task_name" {
  type = string
}

variable "docker_image" {
  type = string
}

variable "cpu" {
  type = number
  default = 256
}

variable "memory" {
  type = number
  default = 512
}
