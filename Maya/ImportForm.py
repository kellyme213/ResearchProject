# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'ImportForm.ui'
#
# Created by: PyQt5 UI code generator 5.14.1
#
# WARNING! All changes made in this file will be lost!


from PySide2 import QtCore, QtGui, QtWidgets


class Ui_ImportForm(object):
    def setupUi(self, ImportForm):
        ImportForm.setObjectName("ImportForm")
        ImportForm.resize(401, 300)
        self.refreshCameraButton = QtWidgets.QPushButton(ImportForm)
        self.refreshCameraButton.setGeometry(QtCore.QRect(10, 230, 161, 32))
        self.refreshCameraButton.setObjectName("refreshCameraButton")
        self.bakeButton = QtWidgets.QPushButton(ImportForm)
        self.bakeButton.setGeometry(QtCore.QRect(230, 230, 112, 32))
        self.bakeButton.setObjectName("bakeButton")
        self.cameraListLabel = QtWidgets.QLabel(ImportForm)
        self.cameraListLabel.setGeometry(QtCore.QRect(10, 10, 121, 16))
        self.cameraListLabel.setObjectName("cameraListLabel")
        self.fpsLabel = QtWidgets.QLabel(ImportForm)
        self.fpsLabel.setGeometry(QtCore.QRect(210, 130, 58, 16))
        self.fpsLabel.setObjectName("fpsLabel")
        self.importLabel = QtWidgets.QLabel(ImportForm)
        self.importLabel.setGeometry(QtCore.QRect(210, 10, 121, 16))
        self.importLabel.setObjectName("importLabel")
        self.selectButton = QtWidgets.QPushButton(ImportForm)
        self.selectButton.setGeometry(QtCore.QRect(210, 30, 112, 32))
        self.selectButton.setObjectName("selectButton")
        self.selectedFileLabel = QtWidgets.QLabel(ImportForm)
        self.selectedFileLabel.setGeometry(QtCore.QRect(210, 60, 171, 61))
        self.selectedFileLabel.setWordWrap(True)
        self.selectedFileLabel.setObjectName("selectedFileLabel")
        self.fpsTextEdit = QtWidgets.QTextEdit(ImportForm)
        self.fpsTextEdit.setGeometry(QtCore.QRect(320, 190, 71, 25))
        self.fpsTextEdit.setObjectName("fpsTextEdit")
        self.cameraListWidget = QtWidgets.QListWidget(ImportForm)
        self.cameraListWidget.setGeometry(QtCore.QRect(10, 30, 181, 192))
        self.cameraListWidget.setObjectName("cameraListWidget")
        self.autoRadioButton = QtWidgets.QRadioButton(ImportForm)
        self.autoRadioButton.setGeometry(QtCore.QRect(210, 160, 100, 20))
        self.autoRadioButton.setChecked(True)
        self.autoRadioButton.setObjectName("autoRadioButton")
        self.customRadioButton = QtWidgets.QRadioButton(ImportForm)
        self.customRadioButton.setGeometry(QtCore.QRect(210, 190, 100, 20))
        self.customRadioButton.setObjectName("customRadioButton")

        self.retranslateUi(ImportForm)
        QtCore.QMetaObject.connectSlotsByName(ImportForm)

    def retranslateUi(self, ImportForm):
        _translate = QtCore.QCoreApplication.translate
        ImportForm.setWindowTitle(_translate("ImportForm", "Import"))
        self.refreshCameraButton.setText(_translate("ImportForm", "Get Scene Cameras"))
        self.bakeButton.setText(_translate("ImportForm", "Bake Keys"))
        self.cameraListLabel.setText(_translate("ImportForm", "Scene Camera List"))
        self.fpsLabel.setText(_translate("ImportForm", "FPS"))
        self.importLabel.setText(_translate("ImportForm", "Select Camera File"))
        self.selectButton.setText(_translate("ImportForm", "Select"))
        self.selectedFileLabel.setText(_translate("ImportForm", "Select a .camout file!"))
        self.autoRadioButton.setText(_translate("ImportForm", "Auto FPS"))
        self.customRadioButton.setText(_translate("ImportForm", "Custom FPS"))
