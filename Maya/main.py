import sys
pathToProject = '/Users/Michael/Desktop/Files/Documents/School/Junior Year/Spring/Research/ResearchProject/Maya'
if ((pathToProject in sys.path) == False):
    sys.path.append(pathToProject)
import os
import Ui_ImportForm
import imp
import pymel.core as pm

#http://www.brechtos.com/using-qt-designer-pyside-create-maya-2014-editor-windows/
from PySide2 import QtWidgets
from shiboken2 import wrapInstance
import maya.OpenMayaUI as omui

def maya_main_window():
    main_window_ptr = omui.MQtUtil.mainWindow()
    return wrapInstance(long(main_window_ptr), QWidget)
        
class ControlMainWindow(QtWidgets.QDialog):
    def __init__(self, parent=None):
        super(ControlMainWindow, self).__init__(parent)
        self.setWindowFlags(QtCore.Qt.Tool)
        self.ui =  Ui_ImportForm.Ui_ImportForm()
        self.ui.setupUi(self)
        #self.ui.pushButton.clicked.connect(self.someFunc)
                
    def someFunc(self):
        print 'Hello {0} !'
        
                
if __name__ == "__main__":
    imp.reload(Ui_ImportForm)
    myWin = ControlMainWindow(parent=maya_main_window())
    myWin.show()
