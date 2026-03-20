locals {
  # createdate를 공통 태그로 강제 삽입, 사용자 tags와 merge
  tags = merge(
    {
      CreateDate = var.createdate
    },
    var.tags
  )
}
