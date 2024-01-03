# aws_s3_bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true

  tags = local.common_tags
}

# aws_s3_bucket_policy

resource "aws_s3_bucket_policy" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "${data.aws_elb_service_account.root.arn}"
          },
          "Action" : "s3:PutObject",
          "Resource" : "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
        },
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "delivery.logs.amazonaws.com"
          },
          "Action" : "s3:PutObject",
          "Resource" : "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
          "Condition" : {
            "StringEquals" : {
              "s3:x-amz-acl" : "bucket-owner-full-control"
            }
          }
        },
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "delivery.logs.amazonaws.com"
          },
          "Action" : "s3:GetBucketAcl",
          "Resource" : "arn:aws:s3:::${local.s3_bucket_name}"
        }
      ]
  })
}

#   policy = data.aws_iam_policy_document.allow_access.json

# data "aws_iam_policy_document" "allow_access" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = ["123456789012"]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       aws_s3_bucket.example.arn,
#       "${aws_s3_bucket.example.arn}/*",
#     ]
#   }
# }


# aws_s3_object

resource "aws_s3_object" "website" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "/website/index.html"
  source = "./website/index.html"

  tags = local.common_tags

}

resource "aws_s3_object" "graphic" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "/website/Globo_logo_Vert.png"
  source = "./website/Globo_logo_Vert.png"

  tags = local.common_tags

}