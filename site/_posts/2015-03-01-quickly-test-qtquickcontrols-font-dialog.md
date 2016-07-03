---
layout: post
title:  "Quickly Test QtQuickControls Font Dialog"
date:   2014-03-01 20:40
categories: qt programming
---

We checkout `qtbase`, `qtxmlpatterns`, `qtdeclarative`, and `qtquickcontrols` sources from their stable branch in sequence. Use the patch below to enable `PURE_QML_ONLY` definition.

Under `~/qtproject/qtquickcontrols` directory,

    $ git diff
    diff --git a/src/dialogs/plugin.cpp b/src/dialogs/plugin.cpp
    index 74672f6..f7523f5 100644
    --- a/src/dialogs/plugin.cpp
    +++ b/src/dialogs/plugin.cpp
    @@ -59,7 +59,7 @@
     #include <private/qguiapplication_p.h>
     #include <qpa/qplatformintegration.h>
    
    -//#define PURE_QML_ONLY
    +#define PURE_QML_ONLY
     //#define DEBUG_REGISTRATION
    
     static void initResources()
    $

We need to build  `qtbase`, `qtxmlpatterns`, `qtdeclarative`, and `qtquickcontrols` sources from their stable branch in correct sequence, with the developer build options being set with qtbase module.

Under `~/qtproject/qtbase` directory,

    $ ./configure -developer-build -opensource -confirm-license -verbose
    $ time make -j 64
    
Under `~/qtproject/qtxmlpatterns` directory,
    
    $ ../qtbase/bin/qmake && time make -j 64
    
Under `~/qtproject/qtdeclarative` directory,
    
    $ ../qtbase/bin/qmake && time make -j 64

Under `~/qtproject/qtquickcontrols` directory,
    
    $ ../qtbase/bin/qmake && time make -j 64

Under `~/qtproject` directory,
    
    $ qtbase/bin/qmlscene qtquickcontrols/examples/quick/dialogs/systemdialogs/FontDialogs.qml

The above steps was used to [implement input for entering non-standard font size](https://codereview.qt-project.org/82603) for Qt Quick Controls [Font Dialog](http://qt-project.org/doc/qt-5/qml-qtquick-dialogs-fontdialog.html).

Special thanks to [Liang Qi](https://github.com/liangqi) and [J-P Nurmi](https://github.com/jpnurmi) for helping along the way.