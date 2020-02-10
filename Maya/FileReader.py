class FileReader:
	def __init__(self, fileName):
		self.fileName = fileName
		self.data = []
		file = open(self.fileName, "r")
		for line in file:
			lineData = line.split()
			floatData = [
				float(lineData[0]), 
				float(lineData[1]), 
				float(lineData[2]), 
				float(lineData[3]), 
				float(lineData[4]), 
				float(lineData[5]),
				float(lineData[6])
			]
			self.data.append(floatData)
