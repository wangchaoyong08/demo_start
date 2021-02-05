::
::Author:wangchaoyong
::Date:2019-04-13
::
::关闭回显并开启变量延迟
@echo off & setlocal enabledelayedexpansion 
title Program

::指定jar包存放目录
set LIB_DIR=lib

::指定项目名
set PROJECT_NAME=project_demo

::指定日志目录
set LOGS_DIR=logs

::指定主类
set Main_Class=com.sohu.Demo

::指定日志文件后缀 
set hh=%time:~0,2%
if /i %hh% LSS 10 (set hh=0%time:~1,1%)
set ARCHIVE_SUFFIX=%date:~0,4%%date:~5,2%%date:~8,2%%hh%%time:~3,2%-%time:~6,2% 

::指定classpath参数，包括指定lib目录下所有的jar
for /f "delims=" %%i in ('dir /b %LIB_DIR%^|findstr /S /I ".*\.jar$"') do (
	set CLASSPATH=%%i;!CLASSPATH!
)
set CLASSPATH=classes;%CLASSPATH%

::备份日志文件
if not exist %LOGS_DIR% (
	md %LOGS_DIR%
)
if exist "%LOGS_DIR%\stdout.log" (
	rename stdout.log stdout.log.ARCHIVE_SUFFIX
)
if exist "%LOGS_DIR%\stderr.log" (
	rename stderr.log stderr.log.ARCHIVE_SUFFIX
)
if exist "%LOGS_DIR%\gc.log" (
	rename gc.log gc.log.ARCHIVE_SUFFIX
)

::指定java虚拟机参数，  -XX:PermSize=128m -XX:MaxPermSize=128m -stdout %LOGS_DIR%/stdout.log -stderr %LOGS_DIR%/stderr.log
set JAVA_ARGS=-server -Xms1024m -Xmx1024m -XX:NewSize=128m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=58 -XX:+DisableExplicitGC -XX:ThreadStackSize=512 -Xloggc:%LOGS_DIR%/gc.log -Dsun.rmi.transport.tcp.readTimeout=5000 -Dsun.rmi.server.exceptionTrace=true

::运行
java %JAVA_ARGS% %Main_Class%
echo "start %PROJECT_NAME% server ......"