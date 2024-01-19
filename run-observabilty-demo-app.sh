#!/bin/bash

OTEL_VERSION=2.0.0
JAR_NAME=observability-demo-app-0.0.1-SNAPSHOT.jar

cd observability-demo-app
if [[ ! -f ./target/${JAR_NAME} ]] ; then
    ./mvnw clean package
fi
if [[ ! -f ./opentelemetry-javaagent.jar ]] ; then
    curl -sOL https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_VERSION}/opentelemetry-javaagent.jar
fi

export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_INSTRUMENTATION_COMMON_EXPERIMENTAL_CONTROLLER_TELEMETRY_ENABLED=true
export OTEL_INSTRUMENTATION_COMMON_EXPERIMENTAL_VIEW_TELEMETRY_ENABLED=true
export OTEL_SERVICE_NAME=observability-demo-app



#export OTEL_RESOURCE_ATTRIBUTES="service.name=observability-demo-app,service.instance.id=localhost:8080"
java -Dotel.metric.export.interval=300 -Dotel.bsp.schedule.delay=300 -javaagent:opentelemetry-javaagent.jar -jar ./target/${JAR_NAME}