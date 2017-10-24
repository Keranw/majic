class Log
	def initialize()
		@f = File.new("Log.txt" , "w")
		
	end

	def AddLog(log)
		@f.puts(log)
	end
	end