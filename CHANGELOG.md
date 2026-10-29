# Changelog

All notable changes to this module are documented here. Versions follow [Semantic Versioning](https://semver.org/).

## v1.0.1

### Fixed

- The deployment bucket's `public-read` ACL and its public-read bucket policy now depend on `aws_s3_bucket_public_access_block.deployment` (and the ACL also on `aws_s3_bucket_ownership_controls.deployment`). New buckets are created with Block Public Access enabled, so on a first apply `PutBucketAcl` and `PutBucketPolicy` could run before the block was lifted and fail with `AccessDenied`.
- The two placeholder Lambda@Edge packages (`archive_file.dummy_request` and `archive_file.dummy_response`) were written to the same `./tmp/dummy.zip`, so one function could be created with the other's package. Each one now has its own `output_path` under the module directory, and each function's `source_code_hash` matches its own archive. Existing functions are not changed (`filename` and `source_code_hash` are ignored after creation).

### Changed

- `application_runtime` now defaults to `nodejs22.x` instead of `nodejs18.x`, which AWS Lambda no longer accepts for new functions. With the old default the module could not be applied from scratch. Consumers that pass `application_runtime` explicitly see no change. A consumer that relied on the old default on existing functions gets an in-place runtime update (and a new published version associated with CloudFront) on its next apply; to keep the old runtime, set `application_runtime = "nodejs18.x"`.
