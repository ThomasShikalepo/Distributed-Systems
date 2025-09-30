@echo off
rem Licensed to the Apache Software Foundation (ASF) under one or more
rem contributor license agreements.

IF [%1] EQU [] (
    echo USAGE: %0 server.properties
    EXIT /B 1
)

SetLocal

IF ["%KAFKA_LOG4J_OPTS%"] EQU [""] (
    set KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:%~dp0../../config/log4j.properties
)

IF ["%KAFKA_HEAP_OPTS%"] EQU [""] (
    rem default heap settings for 64-bit JVM
    set KAFKA_HEAP_OPTS=-Xmx1G -Xms1G
)

"%~dp0kafka-run-class.bat" kafka.Kafka %*

EndLocal
