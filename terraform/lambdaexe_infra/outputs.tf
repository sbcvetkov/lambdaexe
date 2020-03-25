output "repo_url" {
  depends_on = [module.cicd]
  value      = module.cicd.clone_repo_https
}

output "codepipeline_role" {
  depends_on = [module.cicd]
  value      = module.cicd.codepipeline_role
}

output "codebuild_role" {
  depends_on = [module.cicd]
  value      = module.cicd.codebuild_role
}

output "ecr_image_respository_url" {
  depends_on = [aws_ecr_repository.lambdaexe_ecr]
  value      = aws_ecr_repository.lambdaexe_ecr.repository_url
}