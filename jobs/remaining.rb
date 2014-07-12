start = Time.parse "2014-07-11 7:00PM"
start = start.to_f

deadline = Time.parse "2014-07-13 5:30PM"
deadline = deadline.to_f

SCHEDULER.every '1m', :first_in => 0 do |job|
	left = 100 - ((Time.now.to_f-start) / (deadline-start) * 100).to_i
  	send_event('remaining', { value: left })
end