import sys
pathToProject = '/Users/Michael/Desktop/Files/Documents/School/Junior Year/Spring/Research/ResearchProject/Maya'
if ((pathToProject in sys.path) == False):
    sys.path.append(pathToProject)
import os
import ImportForm
import imp
import pymel.core as pm

#http://www.brechtos.com/using-qt-designer-pyside-create-maya-2014-editor-windows/
from PySide2 import QtWidgets, QtCore
from PySide2.QtWidgets import QFileDialog
from shiboken2 import wrapInstance
import maya.OpenMayaUI as omui

def maya_main_window():
    main_window_ptr = omui.MQtUtil.mainWindow()
    return wrapInstance(long(main_window_ptr), QtWidgets.QWidget)
        
class ControlMainWindow(QtWidgets.QDialog):
    def __init__(self, parent=None):
        super(ControlMainWindow, self).__init__(parent)
        self.setWindowFlags(QtCore.Qt.Tool)
        self.ui = ImportForm.Ui_ImportForm()
        self.ui.setupUi(self)
        self.ui.refreshCameraButton.clicked.connect(self.refreshButtonPushed)
        self.ui.selectButton.clicked.connect(self.openFileNameDialog)
    
    def refreshButtonPushed(self):
        cameras = pm.ls('*', ca = True)
        self.ui.cameraListWidget.clear()
        for node in cameras:
            self.ui.cameraListWidget.addItem(node.name())
    
    def openFileNameDialog(self):
        options = QFileDialog.Options()
        fileName, _ = QFileDialog.getOpenFileName(self,"QFileDialog.getOpenFileName()", "","Camera Files (*.camout);;All Files (*)", options=options)
        if fileName:
            self.ui.selectedFileLabel.setText(fileName)
    
                
    def someFunc(self):
        print 'Hello {0} !'
        
                
if __name__ == "__main__":
    imp.reload(ImportForm)
    myWin = ControlMainWindow(parent=maya_main_window())
    myWin.show()
