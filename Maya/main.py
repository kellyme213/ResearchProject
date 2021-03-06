import sys
pathToProject = '/Users/Michael/Desktop/Files/Documents/School/Junior Year/Spring/Research/ResearchProject/Maya'
if ((pathToProject in sys.path) == False):
    sys.path.append(pathToProject)
import os
import ImportForm
import imp
import pymel.core as pm
import pymel.core.datatypes as dtypes
import FileReader
imp.reload(FileReader)

#http://www.brechtos.com/using-qt-designer-pyside-create-maya-2014-editor-windows/
from PySide2 import QtWidgets, QtCore
from PySide2.QtWidgets import QFileDialog
from PySide2.QtWidgets import QMessageBox
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
        bakeFps = fps

        if self.ui.customRadioButton.isChecked():
            try:
                bakeFps = float(self.ui.fpsTextEdit.toPlainText())
                if (bakeFps <= 0):
                    raise Exception
            except Exception:
                self.createErrorPopup("Please enter a number larger than 0 in the textbox or select the Auto FPS option.")
                return


        newPoints = bakeKeys(reader.data, fps, bakeFps)
        matrix = dtypes.TransformationMatrix()
        for line in newPoints:
            matrix.a00 = line[4]
            matrix.a01 = line[5]
            matrix.a02 = line[6]
            matrix.a10 = line[7]
            matrix.a11 = line[8]
            matrix.a12 = line[9]
            matrix.a20 = line[10]
            matrix.a21 = line[11]
            matrix.a22 = line[12]
            
            eulerAngles = matrix.euler
            #print(eulerAngles)
            
            pm.setKeyframe(camera, at = 'translateX', v = 100 * line[1], t = [line[0]])
            pm.setKeyframe(camera, at = 'translateY', v = 100 * line[2], t = [line[0]])
            pm.setKeyframe(camera, at = 'translateZ', v = 100 * line[3], t = [line[0]])
            pm.setKeyframe(camera, at = 'rotateX', v = 180 * eulerAngles[0] / 3.14, t = [line[0]])
            pm.setKeyframe(camera, at = 'rotateY', v = 180 * eulerAngles[1] / 3.14, t = [line[0]])
            pm.setKeyframe(camera, at = 'rotateZ', v = 180 * eulerAngles[2] / 3.14, t = [line[0]])
     
    def createErrorPopup(self, str = "Please enter a valid value."):
        messageBox = QMessageBox(self)
        messageBox.setText(str)
        messageBox.setIcon(QMessageBox.Critical)
        messageBox.setStandardButtons(QMessageBox.Ok)
        messageBox.show()
     
def sample(time, dataPoints, startLocation):
    numPoints = len(dataPoints)
    for x in range(startLocation, numPoints - 1):
        if (dataPoints[x + 1][0] > time):
            deltaT = dataPoints[x + 1][0] - dataPoints[x][0]
            alpha = (time - dataPoints[x][0]) / deltaT
            newPoint = []
            for y in range(0, len(dataPoints[x])):
                newPoint.append((1.0 - alpha) * dataPoints[x + 1][y] + alpha * dataPoints[x][y])
            return (newPoint, x)
            
    return ([], -1)
            
            
            
def bakeKeys(dataPoints, fps, bakeFps):
    timeSlice = 1.0 / float(bakeFps)
    newPoints = []
    numNewPoints = 1
    
    time = 0.0
    currentIndex = 0
    point = []
    tuple = sample(time, dataPoints, currentIndex)
    point = tuple[0]
    currentIndex = tuple[1]
    
    while (len(point) > 0):
        point[0] = numNewPoints
        numNewPoints += int(fps / bakeFps)
        newPoints.append(point)
        time += timeSlice
        tuple = sample(time, dataPoints, currentIndex)
        point = tuple[0]
        currentIndex = tuple[1]
    return newPoints
    

if __name__ == "__main__":
    imp.reload(ImportForm)
    myWin = ControlMainWindow(parent=maya_main_window())
    myWin.show()
