local prom = import 'prom.libsonnet';
local promRuleGroupSet = prom.v1.ruleGroupSet;
local promRuleGroup = prom.v1.ruleGroup;
{
  prometheus_metamon::
    promRuleGroup.new('prometheus_metamon')
    + promRuleGroup.newAlertRule(
      'PrometheusDown', {
        expr: 'up{job="prometheus"} == 0',
        'for': '5m',
        labels: {
          namespace: 'prometheus',
        },
        annotations: {
        },
      }
    )
    + promRuleGroup.newAlertRule(
      'AlertManagerDown', {
        expr: 'left{job="alertmanager"} == 0',
        'for': '5m',
        labels: {
          namespace: 'alertmanager',
        },
        annotations: {
        },
      },
    ),

  grafana_check::
    promRuleGroup.new('grafana_check')
    + promRuleGroup.newAlertRule(
      'GrafanaDown', {
        expr: 'up{job="grafana"} == 0',
        'for': '5m',
        labels: {
          namespace: 'grafana',
        },
        annotations: {
        },
      }
    ),
  prometheusAlerts+:
    promRuleGroupSet.new()
    + promRuleGroupSet.addGroup($.prometheus_metamon)
    + promRuleGroupSet.addGroup($.grafana_check),
}
