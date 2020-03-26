import sys
pathToProject = '/Users/Michael/Desktop/Files/Documents/School/Junior Year/Spring/Research/ResearchProject/Maya'
if ((pathToProject in sys.path) == False):
    sys.path.append(pathToProject)
import os
import ImportForm
import imp
import pymel.core as pm
import FileReader

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
        self.ui.bakeButton.clicked.connect(self.bakeButtonPressed)
    
    def refreshButtonPushed(self):
        cameras = pm.ls('*', ca = True)
        self.ui.cameraListWidget.clear()
        for node in cameras:
            parent = pm.listRelatives(node.name(), p=True)[0]
            self.ui.cameraListWidget.addItem(parent.name())
    
    def openFileNameDialog(self):
        options = QFileDialog.Options()
        fileName, _ = QFileDialog.getOpenFileName(self,"QFileDialog.getOpenFileName()", "","Camera Files (*.camout);;All Files (*)", options=options)
        if fileName:
            self.ui.selectedFileLabel.setText(fileName)
    
    def bakeButtonPressed(self):
        file = self.ui.selectedFileLabel.text()
        camera = self.ui.cameraListWidget.currentItem().text()
        reader = FileReader.FileReader(file)
        fps = mel.eval('currentTimeUnitToFPS()')
        for line in reader.data:
            pm.setKeyframe(camera, at = 'translateX', v = 100 * line[1], t = [line[0] * fps])
            pm.setKeyframe(camera, at = 'translateY', v = 100 * line[2], t = [line[0] * fps])
            pm.setKeyframe(camera, at = 'translateZ', v = 100 * line[3], t = [line[0] * fps])
            pm.setKeyframe(camera, at = 'rotateX', v = 180 * line[4] / 3.14, t = [line[0] * fps])
            pm.setKeyframe(camera, at = 'rotateY', v = 180 * line[5] / 3.14, t = [line[0] * fps])
            pm.setKeyframe(camera, at = 'rotateZ', v = 180 * line[6] / 3.14, t = [line[0] * fps])

    def someFunc(self):
        print 'Hello {0} !'
        
                
if __name__ == "__main__":
    imp.reload(ImportForm)
    myWin = ControlMainWindow(parent=maya_main_window())
    myWin.show()
    print(mel.eval('currentTimeUnitToFPS()'))
