# Sky Dolly 简体中文版

Sky Dolly 可录制和回放 Microsoft Flight Simulator 中的飞行，并管理飞行日志、编队和保存的位置。本版本基于 Sky Dolly 0.20.0，提供简体中文和英文界面。

## 下载

[下载安装版 EXE](https://github.com/LiYichen2894528983/SkyDolly/releases/download/v0.20.0-zh-CN.1/SkyDolly-0.20.0-zh_CN-Setup.exe) 或 [便携版 ZIP](https://github.com/LiYichen2894528983/SkyDolly/releases/download/v0.20.0-zh-CN.1/SkyDolly-zh_CN.zip)。完整版本说明与校验文件见 [GitHub Release](https://github.com/LiYichen2894528983/SkyDolly/releases/tag/v0.20.0-zh-CN.1)。

## 启动与切换语言

双击 `SkyDolly.exe` 启动。首次运行默认使用简体中文。

在菜单栏的“语言”中选择“简体中文”或“English”，然后选择“重新启动”。也可以选择“稍后”，下次启动时生效。语言选择会自动保存。

录制或暂停录制期间不会允许立即重启。先选择“稍后”，停止录制，再从语言菜单选择相同语言即可重新打开重启提示。

运行时请保留程序目录中的 DLL、`Plugins`、`Resources` 等文件。便携版 ZIP 需要完整解压，不能只单独移动 EXE。

程序启动后会尝试连接飞行模拟器。未启动模拟器时显示“未连接”属于正常状态，仍可管理已有飞行日志。

## 翻译说明

翻译采用 Qt 标准 TS/QM 机制，应用翻译嵌入 EXE，Qt 标准对话框翻译随程序包提供。中文用语按照软件操作习惯和航空术语处理，统一使用“回放”“飞行日志”“飞机注册号”“指示空速”“真航向”等表达。

机型名称、已有日志内容、位置名称、国家代码、品牌、文件格式和模拟器变量标识保留原始数据。切换语言不会翻译或改写已有记录。

## 从源码构建

依赖：Qt 6.8.3 MinGW 64 位版、匹配的 MinGW 13.1、CMake 3.29 或更高版本、Microsoft Flight Simulator SimConnect SDK，以及仓库的三个第三方子模块。

将 `MSFS_SDK` 环境变量设为 SDK 根目录，其中应包含 `SimConnect SDK/include/SimConnect.h` 和 `SimConnect SDK/lib/SimConnect.lib`、`SimConnect.dll`。

```powershell
git clone --recurse-submodules https://github.com/LiYichen2894528983/SkyDolly.git
cd SkyDolly
cmake -S . -B build -G "MinGW Makefiles" -DCMAKE_PREFIX_PATH="C:/Qt/6.8.3/mingw_64" -DCMAKE_BUILD_TYPE=Release -DSKY_TESTS=ON -DSKY_FETCH_EGM=ON
cmake --build build --parallel 4
ctest --test-dir build -R "^(LanguageTest|SkyMathTest|SortTest|NameTest|PositionParserTest|CsvParserTest|SkySearchTest|Csv.*ImportTest|GpxImportTest|Kml.*ImportTest|IgcImportTest)$" --output-on-failure
```

翻译文件位于 `src/SkyDolly/i18n/SkyDolly_zh_CN.ts`，可用 Qt Linguist 编辑。更新翻译源文本使用 `lupdate src -no-obsolete -ts src/SkyDolly/i18n/SkyDolly_zh_CN.ts`。

`tools/check-translations.ps1` 检查翻译是否完整，以及 `%1`、`%n` 等格式占位符是否保留。`tools/package-windows.ps1` 可在编译完成后生成便携程序目录及 ZIP，并检查连接插件和关键运行库。

本次已验证：13 个 Sky Dolly 项目测试通过，中英文界面与语言选择保存正常，便携版在不含 Qt 开发环境的 PATH 中可启动并正常退出。未进行实际飞行录制与回放测试。GeographicLib 的 189 个上游测试默认未编译，因此不计入这 13 个项目测试。

程序包附带 EGM2008-5 地球重力模型，用于 WGS84 椭球高度与大地水准面高度转换。

原项目许可与第三方说明见 `LICENSE` 和 `THIRD_PARTY.md`。
