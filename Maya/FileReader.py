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
				float(lineData[6]),
				float(lineData[7]),
				float(lineData[8]),
				float(lineData[9]),
				float(lineData[10]),
				float(lineData[11]),
				float(lineData[12])

			]
			self.data.append(floatData)
