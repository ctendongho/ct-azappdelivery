#!/usr/bin/env python3

import json
from pathlib import Path


DATASOURCE = {
    "type": "prometheus",
    "uid": "prometheus"
}

panels = []
panel_id = 1


def next_panel_id():
    global panel_id
    current_id = panel_id
    panel_id += 1
    return current_id


def stat_panel(title, expression, x, y, width):
    return {
        "id": next_panel_id(),
        "type": "stat",
        "title": title,
        "datasource": DATASOURCE,
        "gridPos": {
            "x": x,
            "y": y,
            "w": width,
            "h": 4
        },
        "targets": [
            {
                "refId": "A",
                "expr": expression,
                "editorMode": "code",
                "instant": True,
                "range": False
            }
        ],
        "fieldConfig": {
            "defaults": {
                "color": {
                    "mode": "thresholds"
                },
                "mappings": [
                    {
                        "type": "value",
                        "options": {
                            "0": {
                                "text": "DOWN",
                                "color": "red"
                            },
                            "1": {
                                "text": "UP",
                                "color": "green"
                            }
                        }
                    }
                ],
                "thresholds": {
                    "mode": "absolute",
                    "steps": [
                        {
                            "color": "red",
                            "value": None
                        },
                        {
                            "color": "green",
                            "value": 1
                        }
                    ]
                }
            },
            "overrides": []
        },
        "options": {
            "colorMode": "value",
            "graphMode": "none",
            "justifyMode": "center",
            "orientation": "auto",
            "textMode": "value",
            "reduceOptions": {
                "calcs": [
                    "lastNotNull"
                ],
                "fields": "",
                "values": False
            }
        }
    }


def total_targets_panel():
    panel = stat_panel(
        title="All Monitored Targets",
        expression="count(up == 1)",
        x=0,
        y=0,
        width=6
    )

    panel["fieldConfig"]["defaults"]["mappings"] = []

    panel["fieldConfig"]["defaults"]["thresholds"] = {
        "mode": "absolute",
        "steps": [
            {
                "color": "red",
                "value": None
            },
            {
                "color": "yellow",
                "value": 5
            },
            {
                "color": "green",
                "value": 6
            }
        ]
    }

    return panel


def timeseries_panel(
    title,
    targets,
    x,
    y,
    unit,
    minimum=None,
    maximum=None
):
    field_defaults = {
        "unit": unit
    }

    if minimum is not None:
        field_defaults["min"] = minimum

    if maximum is not None:
        field_defaults["max"] = maximum

    return {
        "id": next_panel_id(),
        "type": "timeseries",
        "title": title,
        "datasource": DATASOURCE,
        "gridPos": {
            "x": x,
            "y": y,
            "w": 12,
            "h": 8
        },
        "targets": targets,
        "fieldConfig": {
            "defaults": field_defaults,
            "overrides": []
        },
        "options": {
            "legend": {
                "displayMode": "table",
                "placement": "bottom",
                "showLegend": True,
                "calcs": [
                    "lastNotNull"
                ]
            },
            "tooltip": {
                "mode": "multi",
                "sort": "desc"
            }
        }
    }


def prometheus_target(ref_id, expression, legend):
    return {
        "refId": ref_id,
        "expr": expression,
        "legendFormat": legend,
        "editorMode": "code",
        "range": True
    }


# ------------------------------------------------------------------
# Device addresses
# ------------------------------------------------------------------

vmss01 = "10.10.11.4:9182"
vmss02 = "10.10.11.5:9182"
sql01 = "10.10.21.10:9182"
sql02 = "10.10.22.10:9182"
main = "localhost:9100"
prometheus = "localhost:9090"


# ------------------------------------------------------------------
# Target status panels
# ------------------------------------------------------------------

panels.append(total_targets_panel())

panels.append(
    stat_panel(
        "ct-azappvmss01 Status",
        f'up{{instance="{vmss01}"}}',
        6,
        0,
        6
    )
)

panels.append(
    stat_panel(
        "ct-azappvmss02 Status",
        f'up{{instance="{vmss02}"}}',
        12,
        0,
        6
    )
)

panels.append(
    stat_panel(
        "ct-azappsql01 Status",
        f'up{{instance="{sql01}"}}',
        18,
        0,
        6
    )
)

panels.append(
    stat_panel(
        "ct-azappsql02 Status",
        f'up{{instance="{sql02}"}}',
        0,
        4,
        8
    )
)

panels.append(
    stat_panel(
        "ct-azappmain Status",
        f'up{{instance="{main}"}}',
        8,
        4,
        8
    )
)

panels.append(
    stat_panel(
        "Prometheus Server Status",
        f'up{{instance="{prometheus}"}}',
        16,
        4,
        8
    )
)


# ------------------------------------------------------------------
# VMSS CPU
# ------------------------------------------------------------------

panels.append(
    timeseries_panel(
        title="ct-azappvmss01 and ct-azappvmss02 CPU Usage",
        targets=[
            prometheus_target(
                "A",
                (
                    "100 - (avg(rate("
                    f'windows_cpu_time_total{{instance="{vmss01}",mode="idle"}}'
                    "[5m])) * 100)"
                ),
                "ct-azappvmss01"
            ),
            prometheus_target(
                "B",
                (
                    "100 - (avg(rate("
                    f'windows_cpu_time_total{{instance="{vmss02}",mode="idle"}}'
                    "[5m])) * 100)"
                ),
                "ct-azappvmss02"
            )
        ],
        x=0,
        y=8,
        unit="percent",
        minimum=0,
        maximum=100
    )
)


# ------------------------------------------------------------------
# VMSS memory
# ------------------------------------------------------------------

panels.append(
    timeseries_panel(
        title="ct-azappvmss01 and ct-azappvmss02 Memory Usage",
        targets=[
            prometheus_target(
                "A",
                (
                    "(1 - ("
                    f'windows_memory_available_bytes{{instance="{vmss01}"}}'
                    " / "
                    f'windows_memory_physical_total_bytes{{instance="{vmss01}"}}'
                    ")) * 100"
                ),
                "ct-azappvmss01"
            ),
            prometheus_target(
                "B",
                (
                    "(1 - ("
                    f'windows_memory_available_bytes{{instance="{vmss02}"}}'
                    " / "
                    f'windows_memory_physical_total_bytes{{instance="{vmss02}"}}'
                    ")) * 100"
                ),
                "ct-azappvmss02"
            )
        ],
        x=12,
        y=8,
        unit="percent",
        minimum=0,
        maximum=100
    )
)


# ------------------------------------------------------------------
# SQL CPU
# ------------------------------------------------------------------

panels.append(
    timeseries_panel(
        title="ct-azappsql01 and ct-azappsql02 CPU Usage",
        targets=[
            prometheus_target(
                "A",
                (
                    "100 - (avg(rate("
                    f'windows_cpu_time_total{{instance="{sql01}",mode="idle"}}'
                    "[5m])) * 100)"
                ),
                "ct-azappsql01"
            ),
            prometheus_target(
                "B",
                (
                    "100 - (avg(rate("
                    f'windows_cpu_time_total{{instance="{sql02}",mode="idle"}}'
                    "[5m])) * 100)"
                ),
                "ct-azappsql02"
            )
        ],
        x=0,
        y=16,
        unit="percent",
        minimum=0,
        maximum=100
    )
)


# ------------------------------------------------------------------
# SQL memory
# ------------------------------------------------------------------

panels.append(
    timeseries_panel(
        title="ct-azappsql01 and ct-azappsql02 Memory Usage",
        targets=[
            prometheus_target(
                "A",
                (
                    "(1 - ("
                    f'windows_memory_available_bytes{{instance="{sql01}"}}'
                    " / "
                    f'windows_memory_physical_total_bytes{{instance="{sql01}"}}'
                    ")) * 100"
                ),
                "ct-azappsql01"
            ),
            prometheus_target(
                "B",
                (
                    "(1 - ("
                    f'windows_memory_available_bytes{{instance="{sql02}"}}'
                    " / "
                    f'windows_memory_physical_total_bytes{{instance="{sql02}"}}'
                    ")) * 100"
                ),
                "ct-azappsql02"
            )
        ],
        x=12,
        y=16,
        unit="percent",
        minimum=0,
        maximum=100
    )
)


# ------------------------------------------------------------------
# Windows disk usage
# ------------------------------------------------------------------

panels.append(
    timeseries_panel(
        title=(
            "ct-azappvmss01, ct-azappvmss02, "
            "ct-azappsql01 and ct-azappsql02 Disk Usage"
        ),
        targets=[
            prometheus_target(
                "A",
                (
                    "100 - (("
                    f'windows_logical_disk_free_bytes{{instance="{vmss01}",'
                    'volume!~"HarddiskVolume.*"}}'
                    " / "
                    f'windows_logical_disk_size_bytes{{instance="{vmss01}",'
                    'volume!~"HarddiskVolume.*"}}'
                    ") * 100)"
                ),
                "ct-azappvmss01 {{volume}}"
            ),
            prometheus_target(
                "B",
                (
                    "100 - (("
                    f'windows_logical_disk_free_bytes{{instance="{vmss02}",'
                    'volume!~"HarddiskVolume.*"}}'
                    " / "
                    f'windows_logical_disk_size_bytes{{instance="{vmss02}",'
                    'volume!~"HarddiskVolume.*"}}'
                    ") * 100)"
                ),
                "ct-azappvmss02 {{volume}}"
            ),
            prometheus_target(
                "C",
                (
                    "100 - (("
                    f'windows_logical_disk_free_bytes{{instance="{sql01}",'
                    'volume!~"HarddiskVolume.*"}}'
                    " / "
                    f'windows_logical_disk_size_bytes{{instance="{sql01}",'
                    'volume!~"HarddiskVolume.*"}}'
                    ") * 100)"
                ),
                "ct-azappsql01 {{volume}}"
            ),
            prometheus_target(
                "D",
                (
                    "100 - (("
                    f'windows_logical_disk_free_bytes{{instance="{sql02}",'
                    'volume!~"HarddiskVolume.*"}}'
                    " / "
                    f'windows_logical_disk_size_bytes{{instance="{sql02}",'
                    'volume!~"HarddiskVolume.*"}}'
                    ") * 100)"
                ),
                "ct-azappsql02 {{volume}}"
            )
        ],
        x=0,
        y=24,
        unit="percent",
        minimum=0,
        maximum=100
    )
)


# ------------------------------------------------------------------
# Windows network throughput
# ------------------------------------------------------------------

panels.append(
    timeseries_panel(
        title=(
            "ct-azappvmss01, ct-azappvmss02, "
            "ct-azappsql01 and ct-azappsql02 Network Throughput"
        ),
        targets=[
            prometheus_target(
                "A",
                (
                    "sum(rate("
                    f'windows_net_bytes_received_total{{instance="{vmss01}"}}'
                    "[5m]))"
                ),
                "ct-azappvmss01 received"
            ),
            prometheus_target(
                "B",
                (
                    "sum(rate("
                    f'windows_net_bytes_sent_total{{instance="{vmss01}"}}'
                    "[5m]))"
                ),
                "ct-azappvmss01 sent"
            ),
            prometheus_target(
                "C",
                (
                    "sum(rate("
                    f'windows_net_bytes_received_total{{instance="{vmss02}"}}'
                    "[5m]))"
                ),
                "ct-azappvmss02 received"
            ),
            prometheus_target(
                "D",
                (
                    "sum(rate("
                    f'windows_net_bytes_sent_total{{instance="{vmss02}"}}'
                    "[5m]))"
                ),
                "ct-azappvmss02 sent"
            ),
            prometheus_target(
                "E",
                (
                    "sum(rate("
                    f'windows_net_bytes_received_total{{instance="{sql01}"}}'
                    "[5m]))"
                ),
                "ct-azappsql01 received"
            ),
            prometheus_target(
                "F",
                (
                    "sum(rate("
                    f'windows_net_bytes_sent_total{{instance="{sql01}"}}'
                    "[5m]))"
                ),
                "ct-azappsql01 sent"
            ),
            prometheus_target(
                "G",
                (
                    "sum(rate("
                    f'windows_net_bytes_received_total{{instance="{sql02}"}}'
                    "[5m]))"
                ),
                "ct-azappsql02 received"
            ),
            prometheus_target(
                "H",
                (
                    "sum(rate("
                    f'windows_net_bytes_sent_total{{instance="{sql02}"}}'
                    "[5m]))"
                ),
                "ct-azappsql02 sent"
            )
        ],
        x=12,
        y=24,
        unit="Bps"
    )
)


# ------------------------------------------------------------------
# Management server CPU
# ------------------------------------------------------------------

panels.append(
    timeseries_panel(
        title="ct-azappmain CPU Usage",
        targets=[
            prometheus_target(
                "A",
                (
                    "100 - (avg(rate("
                    f'node_cpu_seconds_total{{instance="{main}",mode="idle"}}'
                    "[5m])) * 100)"
                ),
                "ct-azappmain"
            )
        ],
        x=0,
        y=32,
        unit="percent",
        minimum=0,
        maximum=100
    )
)


# ------------------------------------------------------------------
# Management server memory
# ------------------------------------------------------------------

panels.append(
    timeseries_panel(
        title="ct-azappmain Memory Usage",
        targets=[
            prometheus_target(
                "A",
                (
                    "(1 - ("
                    f'node_memory_MemAvailable_bytes{{instance="{main}"}}'
                    " / "
                    f'node_memory_MemTotal_bytes{{instance="{main}"}}'
                    ")) * 100"
                ),
                "ct-azappmain"
            )
        ],
        x=12,
        y=32,
        unit="percent",
        minimum=0,
        maximum=100
    )
)


dashboard = {
    "annotations": {
        "list": []
    },
    "editable": True,
    "graphTooltip": 1,
    "id": None,
    "links": [],
    "panels": panels,
    "refresh": "15s",
    "schemaVersion": 42,
    "tags": [
        "azure",
        "prometheus",
        "grafana",
        "windows",
        "sql-server",
        "infrastructure"
    ],
    "templating": {
        "list": []
    },
    "time": {
        "from": "now-6h",
        "to": "now"
    },
    "timezone": "browser",
    "title": "CT Infrastructure Monitoring",
    "uid": "ct-infrastructure-monitoring",
    "version": 1
}


output_file = Path(
    "/var/lib/grafana/dashboards/"
    "ct-infrastructure-monitoring.json"
)

output_file.write_text(
    json.dumps(
        dashboard,
        indent=2
    ),
    encoding="utf-8"
)

print(f"Dashboard created: {output_file}")
