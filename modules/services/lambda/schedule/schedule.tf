variable lambda_schedules {
  description = "Map of the lambda schedules"
  type = map
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  for_each = var.lambda_schedules

  name = each.value.schedule_name
  description         = "Schedule for ${each.value.function_name} lambda with expression ${each.value.schedule_expression}"
  schedule_expression = each.value.schedule_expression
}

resource "aws_cloudwatch_event_target" "event_target" {
  for_each = var.lambda_schedules

  rule      = aws_cloudwatch_event_rule.event_rule[each.key].name
  target_id = "lambda"
  arn       = each.value.function_arn
}

resource "aws_lambda_permission" "lambda_permission" {
  for_each = var.lambda_schedules

  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule[each.key].arn
}