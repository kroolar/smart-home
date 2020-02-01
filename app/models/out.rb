class Out < ApplicationRecord
	validates :name, presence: true
	
	def self.exist_outputs(current_output = 0)
		outs = [1,2,3,4,5,6,7,8]
		
		Out.all.each do |o|
			next if o.number == current_output
			outs -= [o.number]
		end
		
		outs
	end
end
