cmake_minimum_required(VERSION 3.16)

project(widgets VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

# Content of downloaded design from Figma to Qt or similar
if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appwidgets
    main.cpp
)

qt_add_qml_module(appwidgets
    URI widgets
    QML_FILES
        qml/Main.qml
        qml/components/AppI18n.qml
        qml/components/CommonDialog.qml
        qml/components/LoginDialog.qml
        qml/components/LoadingDialog.qml
        qml/components/ProgressBar.qml
        qml/components/theme/AppTheme.qml
        qml/components/controls/AppButton.qml
        qml/components/controls/AppIconButton.qml
        qml/components/controls/AppCheckBox.qml
        qml/components/controls/AppTextField.qml
        qml/components/controls/LanguageSwitch.qml
        qml/components/controls/AppProgressBar.qml
        qml/components/base/DialogBase.qml
        qml/components/controls/AppEyeIcon.qml
    RESOURCES
        resources/projects/elements.json

)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appwidgets PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appwidgets
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appwidgets
    PRIVATE Qt6::Quick
)

install(TARGETS appwidgets
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
