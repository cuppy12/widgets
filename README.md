# widgets QML 组件库

这是一个基于 Qt Quick/QML 的轻量组件库示例项目，当前包含确认弹窗、登录弹窗、加载弹窗、进度条，以及一组可复用的主题和基础控件。

项目的核心目标是：组件可以直接放进业务页面使用，同时内部保持统一的主题、布局、弹窗行为和交互风格。

## 项目结构

```text
widgets/
├── CMakeLists.txt
├── main.cpp
├── qml/
│   ├── Main.qml
│   └── components/
│       ├── AppI18n.qml
│       ├── CommonDialog.qml
│       ├── LoginDialog.qml
│       ├── LoadingDialog.qml
│       ├── ProgressBar.qml
│       ├── base/
│       │   └── DialogBase.qml
│       ├── controls/
│       │   ├── AppButton.qml
│       │   ├── AppCheckBox.qml
│       │   ├── AppIconButton.qml
│       │   ├── AppProgressBar.qml
│       │   ├── AppTextField.qml
│       │   └── LanguageSwitch.qml
│       └── theme/
│           └── AppTheme.qml
└── resources/
```

建议后续继续按三层组织：

- `theme/`：颜色、圆角、尺寸、间距等设计变量。
- `controls/`：按钮、输入框、勾选框、进度条等基础控件。
- `base/`：复杂组件的公共骨架，例如弹窗基座。
- `components/`：对业务更友好的即插即用组件，例如 `CommonDialog`、`LoginDialog`。
- `AppI18n.qml`：轻量语言状态和翻译字典，用于运行时切换界面语言。

## 运行项目

使用 Qt Creator 打开项目根目录的 `CMakeLists.txt`，选择 Qt 6.8.3 MSVC2022 64bit Kit 后构建运行。

新增 QML 文件后，需要同步加入 `CMakeLists.txt` 的 `qt_add_qml_module(... QML_FILES ...)` 中，否则运行时可能出现 `Type unavailable` 或 qrc 路径找不到的问题。

## 快速使用

在页面中导入组件目录：

```qml
import QtQuick
import QtQuick.Layouts
import "components"
```

使用确认弹窗：

```qml
CommonDialog {
    id: confirmDialog
    dialogTitle: "确认执行此操作？"
    message: "这一步会影响当前设备状态，请确认后继续。"
    confirmText: "确认"
    cancelText: "取消"
    preferredWidth: 320
    draggable: true

    onConfirmed: console.log("用户确认")
    onDenied: console.log("用户取消")
    onDismissed: console.log("用户关闭")
}

AppButton {
    text: "打开弹窗"
    type: AppButton.Primary
    onClicked: confirmDialog.open()
}
```

## 主题 AppTheme

`AppTheme.qml` 是组件库的统一设计变量入口。组件中不要到处硬编码颜色、圆角、间距，优先从 `AppTheme` 读取。

使用方式：

```qml
import "components/theme"

AppTheme {
    id: theme
}

Rectangle {
    color: theme.panel
    radius: theme.dialogRadius
    border.color: theme.borderLight
}
```

常用主题属性：

| 属性 | 作用 |
| --- | --- |
| `primary` | 主色，常用于主按钮和进度条 |
| `primaryHover` | 主按钮 hover 色 |
| `primaryPressed` | 主按钮按下色 |
| `primarySoft` | 浅主色背景 |
| `success` | 成功状态色 |
| `warning` | 警告状态色 |
| `danger` | 错误/危险状态色 |
| `page` | 页面背景 |
| `panel` | 卡片/弹窗背景 |
| `border` | 常规边框 |
| `borderLight` | 弱边框 |
| `textPrimary` | 主文本 |
| `textSecondary` | 次级文本 |
| `textMuted` | 弱文本 |
| `dialogRadius` | 弹窗圆角 |
| `dialogMargin` | 弹窗距离窗口边缘的最小间距 |
| `controlHeight` | 按钮默认高度 |
| `fieldHeight` | 输入框默认高度 |

## 基础控件

基础控件位于 `qml/components/controls`，适合直接在页面或新组件中复用。

### LanguageSwitch

语言切换控件。它本身只负责显示语言选项和发出选择信号，真正的语言状态建议交给 `AppI18n`。

```qml
import "components"
import "components/controls"

AppI18n {
    id: i18n
}

LanguageSwitch {
    currentLanguage: i18n.language
    languages: i18n.languageOptions
    label: i18n.t("language.label")

    onLanguageSelected: function(language) {
        i18n.setLanguage(language);
    }
}
```

关键属性：

| 属性 | 说明 |
| --- | --- |
| `currentLanguage` | 当前语言代码，例如 `zh_CN`、`en_US` |
| `languages` | 语言选项数组，元素格式为 `{ "code": "...", "label": "..." }` |
| `label` | 左侧说明文本 |

信号：

| 信号 | 说明 |
| --- | --- |
| `languageSelected(language)` | 用户选择语言时触发 |

### AppButton

自绘按钮，避免 Qt 原生样式下自定义 `Button.background/contentItem` 产生警告。

```qml
import "components/controls"

AppButton {
    text: "保存"
    type: AppButton.Primary
    minimumWidth: 80
    controlHeight: 32
    onClicked: save()
}
```

关键属性：

| 属性 | 说明 |
| --- | --- |
| `text` | 按钮文字 |
| `type` | `AppButton.Default`、`AppButton.Primary`、`AppButton.Danger` |
| `enabled` | 是否可点击 |
| `minimumWidth` | 最小宽度 |
| `horizontalPadding` | 横向内边距 |
| `controlHeight` | 按钮高度 |

### AppIconButton

用于关闭按钮、工具按钮等小图标按钮。

```qml
AppIconButton {
    text: "×"
    size: 24
    onClicked: popup.close()
}
```

### AppTextField

自绘输入框，支持标签、占位符、密码模式、密码显隐。

```qml
AppTextField {
    id: passwordField
    label: "密码"
    placeholderText: "请输入密码"
    passwordMode: true
    revealable: true
    onAccepted: login()
}
```

关键属性：

| 属性 | 说明 |
| --- | --- |
| `text` | 输入内容，alias 到内部 `TextInput.text` |
| `label` | 左侧标签 |
| `placeholderText` | 占位提示 |
| `passwordMode` | 是否密码输入 |
| `revealable` | 是否显示密码显隐按钮 |
| `passwordVisible` | 密码是否明文显示 |
| `inputActiveFocus` | 输入框是否聚焦 |

常用方法：

```qml
passwordField.forceInputFocus()
```

### AppCheckBox

自绘勾选框。

```qml
AppCheckBox {
    id: rememberCheck
    text: "记住登录"
    onToggled: console.log(checked)
}
```

关键属性：

| 属性 | 说明 |
| --- | --- |
| `checked` | 是否选中 |
| `text` | 右侧文本 |
| `enabled` | 是否可点击 |

### AppProgressBar

基础进度条。对外兼容组件 `ProgressBar.qml` 只是它的包装，因此业务中通常直接用 `ProgressBar` 即可。

```qml
ProgressBar {
    value: 75
    striped: true
    label: "当前"
}

ProgressBar {
    indeterminate: true
    showText: false
}
```

关键属性：

| 属性 | 说明 |
| --- | --- |
| `minimum` / `maximum` | 进度范围 |
| `value` | 当前值 |
| `indeterminate` | 不确定进度加载态 |
| `animated` | 是否启用数值变化动画 |
| `striped` | 是否显示条纹动画 |
| `showText` | 是否显示百分比 |
| `label` | 左侧标签 |
| `status` | `ProgressBar.Normal`、`Success`、`Warning`、`Error` |

## 弹窗基座 DialogBase

`DialogBase.qml` 是确认弹窗、登录弹窗、加载弹窗共同使用的基础弹窗。它负责：

- 使用 `Basic.Popup` 构建弹窗，避免 native style 自定义警告。
- 根据窗口大小自动计算弹窗缩放比例。
- 限制弹窗最大宽度、最小宽度和屏幕边距。
- 支持拖动标题栏移动弹窗。
- 统一标题、描述、图标、右上角关闭按钮、内容区和底部按钮区。

常用属性：

| 属性 | 说明 |
| --- | --- |
| `title` | 标题文本 |
| `subtitle` | 描述文本 |
| `showIcon` | 是否显示左侧图标 |
| `iconText` | 图标文本 |
| `iconColor` | 图标文字颜色 |
| `iconBackgroundColor` | 图标背景色 |
| `iconSize` | 图标尺寸 |
| `preferredWidth` | 推荐宽度 |
| `minDialogWidth` | 最小宽度 |
| `maxDialogWidth` | 最大宽度 |
| `screenMargin` | 弹窗与窗口边缘的最小距离 |
| `showCloseButton` | 是否显示右上角关闭按钮 |
| `closeOnPressOutside` | 点击外部是否关闭 |
| `draggable` | 是否允许拖动 |
| `resetPositionOnOpen` | 每次打开是否重新居中 |
| `footerData` | 底部按钮区内容 |

继承 `DialogBase` 创建新弹窗：

```qml
import QtQuick
import QtQuick.Layouts
import "base"
import "controls"
import "theme"

DialogBase {
    id: root

    property string okText: "知道了"

    title: "提示"
    subtitle: "这是一个新的业务弹窗"
    preferredWidth: 340

    AppTheme {
        id: theme
    }

    Text {
        Layout.fillWidth: true
        text: "这里放业务内容"
        color: theme.textSecondary
        wrapMode: Text.WordWrap
    }

    footerData: [
        AppButton {
            type: AppButton.Primary
            text: root.okText
            onClicked: root.close()
        }
    ]
}
```

## 现有业务组件

### CommonDialog

确认弹窗，适合二次确认场景。

```qml
CommonDialog {
    id: dialog
    dialogTitle: "删除数据？"
    message: "删除后不可恢复。"
    confirmText: "删除"
    cancelText: "取消"

    onConfirmed: removeData()
    onDenied: console.log("cancel")
}
```

额外开放了默认内容插槽：

```qml
CommonDialog {
    dialogTitle: "更多内容"
    message: "下面可以插入自定义内容"

    Text {
        text: "自定义说明、表单或状态都可以放这里"
        wrapMode: Text.WordWrap
    }
}
```

### LoginDialog

登录弹窗。

```qml
LoginDialog {
    id: loginDialog
    dialogTitle: "登录系统"
    subtitle: "使用你的账号继续"
    usernameLabel: "用户"
    passwordLabel: "密码"
    usernamePlaceholder: "请输入用户名"
    passwordPlaceholder: "请输入密码"
    rememberText: "记住登录"

    onLoginRequested: function(username, password, rememberMe) {
        if (username.length === 0 || password.length === 0) {
            errorText = "请输入用户名和密码";
            return;
        }

        login(username, password, rememberMe);
        close();
    }
}
```

### LoadingDialog

加载弹窗。

```qml
LoadingDialog {
    id: loadingDialog
    dialogTitle: "加载中"
    message: "正在请求数据，请稍候。"
    detailText: "网络较慢时可能需要几秒。"
    showCancelButton: true

    onCancelled: request.abort()
}
```

显示确定进度：

```qml
LoadingDialog {
    progress: 0.6
}
```

显示不确定加载：

```qml
LoadingDialog {
    progress: -1
}
```

## 组件库开发约定

1. 新组件优先复用 `AppTheme`，不要在业务组件里散落大量硬编码颜色。
2. 新弹窗优先继承 `DialogBase`，不要复制整套 Popup 布局。
3. 基础控件放到 `controls/`，业务组件放到 `components/` 根目录。
4. 对外属性要少而清晰，优先暴露业务语义，例如 `dialogTitle`、`message`、`confirmText`。
5. 内部实现细节尽量留在基础层，例如拖动、自动缩放、关闭策略、按钮 hover/pressed 状态。
6. 新增 QML 文件后必须更新 `CMakeLists.txt` 的 `QML_FILES`。
7. 不直接自定义原生 `Button`、`TextField`、`CheckBox` 的 `background/contentItem`，当前项目使用自绘基础控件来避免 native style 兼容问题。

## 语言切换

当前项目使用 `AppI18n.qml` 做轻量运行时语言切换。它包含三个部分：

- `language`：当前语言，例如 `zh_CN`。
- `languageOptions`：给 `LanguageSwitch` 使用的语言选项。
- `t(key)`：根据 key 返回当前语言文本。

页面中使用方式：

```qml
AppI18n {
    id: i18n
}

Text {
    text: i18n.t("page.title")
}

CommonDialog {
    dialogTitle: i18n.t("common.dialog.title")
    message: i18n.t("common.dialog.message")
    confirmText: i18n.t("common.confirm")
    cancelText: i18n.t("common.cancel")
}
```

切换语言：

```qml
i18n.setLanguage("en_US")
```

`setLanguage()` 内部也会同步设置 `Qt.uiLanguage`。这样以后如果迁移到 Qt 官方的 `qsTr()`、`.ts`、`.qm` 翻译流程，可以继续利用 Qt 的运行时语言刷新机制。

添加新文案时，在 `AppI18n.qml` 的 `translations` 中为每种语言补同一个 key：

```qml
"zh_CN": {
    "settings.title": "设置"
},
"en_US": {
    "settings.title": "Settings"
}
```

建议组件内部只保留默认文案，业务页面需要多语言时从外部传入翻译后的属性值。例如：

```qml
LoginDialog {
    dialogTitle: i18n.t("login.dialog.title")
    usernameLabel: i18n.t("login.username.label")
    usernamePlaceholder: i18n.t("login.username.placeholder")
    passwordLabel: i18n.t("login.password.label")
    passwordPlaceholder: i18n.t("login.password.placeholder")
    rememberText: i18n.t("login.remember")
}
```

## 常见问题

### Type unavailable

通常是新增 QML 文件没有加入 `CMakeLists.txt`：

```cmake
qt_add_qml_module(appwidgets
    URI widgets
    QML_FILES
        qml/components/NewComponent.qml
)
```

### Cannot override FINAL property

不要在继承 `Popup` 或 `DialogBase` 时重新声明 Qt 已有的 final 属性，例如某些 `contentWidth`、`contentHeight`、`contentItem` 相关名称。组件自己的业务属性建议使用更明确的名字，例如 `dialogTitle`、`message`、`preferredWidth`。

### 当前样式不支持自定义控件

如果看到类似 `The current style does not support customization of this control`，通常是自定义了原生 Controls 的 `background` 或 `contentItem`。当前组件库通过 `QtQuick.Controls.Basic as Basic` 和自绘控件规避这个问题。
