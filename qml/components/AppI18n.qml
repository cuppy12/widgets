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
            "status.login.failed": "登录失败",
            "status.login.userAdded": "已添加用户：",
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
            "login.test.title": "登录后端测试",
            "login.test.desc": "这里单独展示 C++ 模拟后端当前保存的用户数据，并提供添加用户能力。登录弹窗只读取这里的用户列表，不包含用户管理界面。",
            "login.test.passwordPrefix": "测试密码：",
            "login.test.hint": "添加用户后，登录弹窗的下拉列表会同步刷新。",
            "login.test.added": "已添加测试用户：",
            "card.loading.title": "加载弹窗",
            "card.loading.desc": "用于页面加载、请求处理、文件解析等等待场景，可显示不确定加载、进度和取消操作。",
            "card.loading.open": "打开加载弹窗",
            "card.progress.title": "进度弹窗",
            "card.progress.desc": "以弹窗方式展示任务进度，适合上传、下载、批处理等需要明确进度反馈的场景。",
            "card.progress.advance": "打开进度弹窗",
            "card.message.title": "\u6d88\u606f\u63d0\u793a\u63a7\u4ef6",
            "card.message.desc": "\u63d0\u4f9b\u6b63\u5e38/\u6210\u529f\u3001\u8b66\u544a\u3001\u9519\u8bef\u4e09\u79cd\u6d88\u606f\u63d0\u793a\u72b6\u6001\uff0c\u9002\u5408\u9875\u9762\u5185\u72b6\u6001\u53cd\u9988\u548c\u8f7b\u91cf\u63d0\u793a\u3002",
            "status.prefix": "状态：",

            "progress.current": "当前",
            "progress.done": "完成",
            "progress.dialog.title": "任务进度",
            "progress.dialog.message": "正在处理任务，请稍候。",
            "message.normal.title": "\u6b63\u5e38\u4fe1\u606f",
            "message.normal.text": "\u8bbe\u5907\u8fde\u63a5\u6b63\u5e38\uff0c\u5f53\u524d\u4efb\u52a1\u53ef\u7ee7\u7eed\u6267\u884c\u3002",
            "message.warning.title": "\u8b66\u544a\u63d0\u793a",
            "message.warning.text": "\u5f53\u524d\u6e29\u5ea6\u63a5\u8fd1\u4e0a\u9650\uff0c\u8bf7\u6ce8\u610f\u8bbe\u5907\u72b6\u6001\u3002",
            "message.error.title": "\u9519\u8bef\u63d0\u793a",
            "message.error.text": "\u4efb\u52a1\u6267\u884c\u5931\u8d25\uff0c\u8bf7\u68c0\u67e5\u7f51\u7edc\u6216\u8bbe\u5907\u8fde\u63a5\u3002",
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
            "login.error.empty": "请选择用户并输入密码",
            "login.error.unknownUser": "用户不存在，请检查账号",
            "login.error.wrongPassword": "密码错误，请重新输入",
            "login.error.incomplete": "请输入用户名和密码",
            "login.add.title": "用户管理",
            "login.add.expand": "添加",
            "login.add.hide": "收起",
            "login.add.submit": "保存用户",
            "login.add.username.label": "新用户",
            "login.add.password.label": "密码",
            "login.add.username.placeholder": "输入新用户名",
            "login.add.password.placeholder": "至少 6 位密码",
            "login.add.error.empty": "请输入新用户名和密码",
            "login.add.error.weakPassword": "密码至少需要 6 位",
            "login.add.error.duplicate": "该用户已存在",


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
            "status.login.failed": "Login failed",
            "status.login.userAdded": "Added user: ",
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
            "login.test.title": "Login Backend Demo",
            "login.test.desc": "Shows the current user data stored in the C++ mock backend and provides a test-only add-user form. The login dialog only reads this user list.",
            "login.test.passwordPrefix": "Test password: ",
            "login.test.hint": "After adding a user, the login dialog drop-down refreshes automatically.",
            "login.test.added": "Added test user: ",
            "card.loading.title": "Loading Dialog",
            "card.loading.desc": "For page loading, request handling, file parsing, and waiting states. Supports indeterminate loading, progress, and cancellation.",
            "card.loading.open": "Open Loading Dialog",
            "card.progress.title": "Progress Dialog",
            "card.progress.desc": "Shows task progress in a dialog for upload, download, batch processing, and other long-running work.",
            "card.progress.advance": "Open Progress Dialog",
            "card.message.title": "Message Alerts",
            "card.message.desc": "Shows normal, warning, and error message states for inline feedback and lightweight notices.",
            "status.prefix": "Status: ",

            "progress.current": "Current",
            "progress.done": "Done",
            "progress.dialog.title": "Task Progress",
            "progress.dialog.message": "Processing task. Please wait.",
            "message.normal.title": "Normal Message",
            "message.normal.text": "Device connection is healthy. The current task can continue.",
            "message.warning.title": "Warning Message",
            "message.warning.text": "The current temperature is close to the upper limit. Watch the device status.",
            "message.error.title": "Error Message",
            "message.error.text": "Task execution failed. Check the network or device connection.",

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
            "login.error.empty": "Please select an account and enter password",
            "login.error.unknownUser": "Account does not exist",
            "login.error.wrongPassword": "Password is incorrect",
            "login.error.incomplete": "Please select an account and enter password",
            "login.add.title": "User management",
            "login.add.expand": "Add",
            "login.add.hide": "Hide",
            "login.add.submit": "Save user",
            "login.add.username.label": "New account",
            "login.add.password.label": "Password",
            "login.add.username.placeholder": "Enter new account",
            "login.add.password.placeholder": "At least 6 characters",
            "login.add.error.empty": "Enter a new account and password",
            "login.add.error.weakPassword": "Password must be at least 6 characters",
            "login.add.error.duplicate": "This account already exists",


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
