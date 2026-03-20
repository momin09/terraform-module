module "yaml_decoder" {
  source    = "levmel/yaml_json/multidecoder"
  version   = "0.2.3"
  filepaths = ["${var.yaml_dir}/ecr/*.yaml"]
}

module "ecr" {
  for_each = module.yaml_decoder.files
  source = "./template"

  name       = each.key
  createdate = each.value.createdate
  region     = try(each.value.region, "ap-northeast-2")
  tags       = try(each.value.tags, {})
}
