output "id" {
  value = aws_lb.lb.id
}

output "arn" {
  value = aws_lb.lb.arn
}

output "zone_id" {
  value = aws_lb.lb.zone_id
}

output "dns_name" {
  value = aws_lb.lb.dns_name
}

output "listener_arns" {
  value = compact(flatten([
    aws_lb_listener.http.*.arn,
    aws_lb_listener.https.*.arn,
  ]))
}

output "security_group_id" {
  value = aws_security_group.lb.id
}

output "target_group_arn" {
  value = aws_lb_target_group.service.arn
}
