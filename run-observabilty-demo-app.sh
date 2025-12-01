#!/bin/bash

OTEL_VERSION=2.22.0
PYROSCOPE_VERSION=2.1.2
OTEL_PYROSCOPE_VERSION=1.0.4
JAR_NAME=observability-demo-app-0.0.1-SNAPSHOT.jar

# See https://github.com/grafana/pyroscope/blob/main/examples/tracing/java/Dockerfile as example

cd observability-demo-app
if [[ ! -f ./target/${JAR_NAME} ]] ; then
    ./mvnw clean package
fi
if [[ ! -f ./opentelemetry-javaagent.jar ]] ; then
  echo "Downloading OpenTelemetry Java agent"
  curl -sOL https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_VERSION}/opentelemetry-javaagent.jar
fi
if [[ ! -f ./pyroscope.jar ]] ; then
  echo "Downloading Pyroscope Java agent"
  curl -sOL https://github.com/grafana/pyroscope-java/releases/download/v${PYROSCOPE_VERSION}/pyroscope.jar
fi

if [[ ! -f ./pyroscope-otel.jar ]] ; then
  echo "Downloading Pyroscope otel integration"
  curl -sL -o pyroscope-otel.jar  https://github.com/grafana/otel-profiling-java/releases/download/v${OTEL_PYROSCOPE_VERSION}/pyroscope-otel.jar pyroscope-otel.jar
fi

export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_INSTRUMENTATION_COMMON_EXPERIMENTAL_CONTROLLER_TELEMETRY_ENABLED=true
export OTEL_INSTRUMENTATION_COMMON_EXPERIMENTAL_VIEW_TELEMETRY_ENABLED=true
export OTEL_SERVICE_NAME=observability-demo-app

export PYROSCOPE_APPLICATION_NAME=${OTEL_SERVICE_NAME}
export PYROSCOPE_FORMAT=jfr
export PYROSCOPE_PROFILING_INTERVAL=10ms
export PYROSCOPE_PROFILER_EVENT=itimer
export PYROSCOPE_PROFILER_LOCK=10ms
export PYROSCOPE_PROFILER_ALLOC=512k
export PYROSCOPE_UPLOAD_INTERVAL=15s
export PYROSCOPE_LOG_LEVEL=debug
export PYROSCOPE_SERVER_ADDRESS=http://localhost:4040
export OTEL_JAVAAGENT_EXTENSIONS=./pyroscope-otel.jar
export OTEL_PYROSCOPE_ADD_PROFILE_URL=false
export OTEL_PYROSCOPE_ADD_PROFILE_BASELINE_URL=false
export OTEL_PYROSCOPE_START_PROFILING=true

#export OTEL_RESOURCE_ATTRIBUTES="service.name=observability-demo-app,service.instance.id=localhost:8080"
java -Dotel.metric.export.interval=300 -Dotel.bsp.schedule.delay=300 -javaagent:opentelemetry-javaagent.jar -javaagent:pyroscope.jar  -jar ./target/${JAR_NAME}