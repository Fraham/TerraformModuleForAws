variable "function_name" {
  description = "The name of the function having default alarms set"
  type        = list(string)
}
variable "cloud_watch_alarm_topic" {
  type        = string
  description = "The SNS topic for CloudWatch alarms"
  default     = ""
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors_alarm" {
  for_each = toset(var.function_name)
  
  alarm_name          = "${each.value}-LambdaErrors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "${each.value} lambda errors"
  treat_missing_data  = "notBreaching"
  dimensions = {
    FunctionName = each.value
  }
  alarm_actions = var.cloud_watch_alarm_topic != "" ? [var.cloud_watch_alarm_topic] : null
  ok_actions    = var.cloud_watch_alarm_topic != "" ? [var.cloud_watch_alarm_topic] : null
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles_alarm" {
    for_each = toset(var.function_name)
  
  alarm_name          = "${each.value}-LambdaThrottles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "${each.value} lambda throttles"
  treat_missing_data  = "notBreaching"
  dimensions = {
    FunctionName = each.value
  }
  alarm_actions = var.cloud_watch_alarm_topic != "" ? [var.cloud_watch_alarm_topic] : null
  ok_actions    = var.cloud_watch_alarm_topic != "" ? [var.cloud_watch_alarm_topic] : null
}
