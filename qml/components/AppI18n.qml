import QtQuick

QtObject {
    id: root

    property string language: "zh_CN"
    readonly property var languageOptions: [
        { "code": "zh_CN", "label": "中文" },
        { "code": "en_US", "label": "EN" }
    ]

    readonly property var translations: ({
        "zh_CN": {
            "app.title": "Dialog Components",
            "page.title": "组件库测试页",
            "language.label": "语言",

            "status.common.initial": "未操作",
            "status.login.initial": "未登录",
            "status.loading.initial": "未加载",
            "status.common.confirmed": "已确认",
            "status.common.denied": "已取消",
            "status.common.dismissed": "已关闭",
            "status.login.incomplete": "等待输入完整信息",
            "status.login.cancelled": "已取消",
            "status.login.dismissed": "已关闭",
            "status.login.submitted": "已提交：",
            "status.login.remember": "（记住登录）",
            "status.loading.running": "加载中",
            "status.loading.cancelled": "已取消",
            "status.loading.dismissed": "已关闭",
            "status.loading.done": "加载完成",

            "card.common.title": "确认弹窗",
            "card.common.desc": "适合危险操作、二次确认、提示用户继续或取消。标题栏可拖动，宽度可通过 preferredWidth/minDialogWidth/maxDialogWidth 控制。",
            "card.common.open": "打开确认弹窗",
            "card.login.title": "登录弹窗",
            "card.login.desc": "包含用户名、密码、记住登录、错误提示和密码显隐。对外开放 placeholder、按钮文案和登录信号。",
            "card.login.open": "打开登录弹窗",
            "card.loading.title": "加载弹窗",
            "card.loading.desc": "用于页面加载、请求处理、文件解析等等待场景，可显示不确定加载、进度和取消操作。",
            "card.loading.open": "打开加载弹窗",
            "card.progress.title": "进度弹窗",
            "card.progress.desc": "以弹窗方式展示任务进度，适合上传、下载、批处理等需要明确进度反馈的场景。",
            "card.progress.advance": "打开进度弹窗",
            "status.prefix": "状态：",

            "progress.current": "当前",
            "progress.done": "完成",
            "progress.dialog.title": "任务进度",
            "progress.dialog.message": "正在处理任务，请稍候。",
            "progress.dialog.detail": "示例会自动推进进度，完成后可关闭弹窗。",
            "progress.close": "关闭",

            "common.dialog.title": "确认执行此操作？",
            "common.dialog.message": "这一步会影响当前设备状态，请确认后继续。",
            "common.confirm": "确认",
            "common.cancel": "取消",

            "login.dialog.title": "登录系统",
            "login.dialog.subtitle": "使用你的账号继续",
            "login.username.label": "用户",
            "login.password.label": "密码",
            "login.username.placeholder": "请输入用户名",
            "login.password.placeholder": "请输入密码",
            "login.remember": "记住登录",
            "login.error.incomplete": "请输入用户名和密码",


            "loading.dialog.title": "页面加载中",
            "loading.dialog.message": "正在加载组件和业务数据，请稍候。",
            "loading.dialog.detail": "示例会在 2.2 秒后自动关闭。"
        },
        "en_US": {
            "app.title": "Dialog Components",
            "page.title": "Component Library Demo",
            "language.label": "Language",

            "status.common.initial": "No action",
            "status.login.initial": "Not logged in",
            "status.loading.initial": "Not loaded",
            "status.common.confirmed": "Confirmed",
            "status.common.denied": "Cancelled",
            "status.common.dismissed": "Closed",
            "status.login.incomplete": "Waiting for complete input",
            "status.login.cancelled": "Cancelled",
            "status.login.dismissed": "Closed",
            "status.login.submitted": "Submitted: ",
            "status.login.remember": " (remember login)",
            "status.loading.running": "Loading",
            "status.loading.cancelled": "Cancelled",
            "status.loading.dismissed": "Closed",
            "status.loading.done": "Loading complete",

            "card.common.title": "Confirm Dialog",
            "card.common.desc": "Suitable for risky actions, secondary confirmation, and asking the user to continue or cancel. Drag the title area to move it.",
            "card.common.open": "Open Confirm Dialog",
            "card.login.title": "Login Dialog",
            "card.login.desc": "Uses an account drop-down, password input, remember login, error text, and password reveal for industrial touch workflows where typing is inconvenient.",
            "card.login.open": "Open Login Dialog",
            "card.loading.title": "Loading Dialog",
            "card.loading.desc": "For page loading, request handling, file parsing, and waiting states. Supports indeterminate loading, progress, and cancellation.",
            "card.loading.open": "Open Loading Dialog",
            "card.progress.title": "Progress Dialog",
            "card.progress.desc": "Shows task progress in a dialog for upload, download, batch processing, and other long-running work.",
            "card.progress.advance": "Open Progress Dialog",
            "status.prefix": "Status: ",

            "progress.current": "Current",
            "progress.done": "Done",
            "progress.dialog.title": "Task Progress",
            "progress.dialog.message": "Processing task. Please wait.",

            "common.dialog.title": "Confirm this action?",
            "common.dialog.message": "This step will affect the current device state. Please confirm before continuing.",
            "common.confirm": "Confirm",
            "common.cancel": "Cancel",

            "login.dialog.title": "Login",
            "login.dialog.subtitle": "Use your account to continue",
            "login.username.label": "Account",
            "login.password.label": "Password",
            "login.username.placeholder": "Select account",
            "login.password.placeholder": "Enter password",
            "login.remember": "Remember me",
            "login.error.incomplete": "Please select an account and enter password",


            "loading.dialog.title": "Loading Page",
            "loading.dialog.message": "Loading components and business data. Please wait.",
            "loading.dialog.detail": "The demo closes automatically after 2.2 seconds."
        }
    })

    function setLanguage(code) {
        if (!translations[code] || language === code)
            return;

        language = code;
        Qt.uiLanguage = code;
    }

    function t(key) {
        const currentLanguage = language;
        const table = translations[currentLanguage] || translations.zh_CN;
        const fallback = translations.zh_CN || {};
        return table[key] || fallback[key] || key;
    }
}
