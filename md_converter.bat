@echo off
setlocal enabledelayedexpansion

:: ================= 配置区域 =================
:: 源MD文件所在的文件夹名称 (相对于本脚本所在目录)
set SOURCE_FOLDER=md文件

:: 合并后的MD文件名
set MERGED_FILE=CPPKnowledge

:: ===========================================

echo [1/3] 正在检查环境...
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未检测到 Node.js，请先安装 Node.js 并配置环境变量。
    pause
    exit /b
)

where i5ting_toc >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未检测到 i5ting_toc，请运行 'npm install -g i5ting_toc' 进行安装。
    pause
    exit /b
)

echo [2/3] 正在合并 Markdown 文件...
:: 检查源文件夹是否存在
if not exist "%SOURCE_FOLDER%" (
    echo 错误: 找不到源文件夹 "%SOURCE_FOLDER%"，请确认路径正确。
    pause
    exit /b
)

:: 进入源文件夹执行合并操作
:: 使用 type 命令合并所有 .md 文件到上一级目录的指定文件中
:: 注意不要将输出文件放在源文件夹内，否则会导致无限递归合并
pushd "%SOURCE_FOLDER%"
type *.md > "..\%MERGED_FILE%.md"
popd

if exist "%MERGED_FILE%.md" (
    echo 成功: 文件已合并为 %MERGED_FILE%.md
) else (
    echo 错误: 合并失败，未生成目标文件。
    pause
    exit /b
)

echo [3/3] 正在转换为 HTML...
:: 使用 i5ting_toc 转换合并后的文件
:: -f 指定输入文件, -o 表示生成输出目录
call i5ting_toc -f "%MERGED_FILE%.md"

if exist "preview" (
    :: i5ting_toc 默认生成在 preview 文件夹
    :: 为了整洁，我们可以选择保留或移动，这里直接提示用户
    echo 成功: HTML 文件已生成在 "preview" 文件夹中。
    echo 正在打开预览...
    start "" "preview\%MERGED_FILE%.html"
) else (
    echo 警告: 转换完成，但未找到默认的 preview 文件夹，请检查当前目录。
)

if exist "%MERGED_FILE%.md" (
    del /f /q %MERGED_FILE%.md
    echo 删除临时文件 %MERGED_FILE%.md 成功
)
echo.
echo 全部完成！
pause
