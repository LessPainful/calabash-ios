Before do |scenario|
  begin
    Step_index = 0
    Step_line = scenario.raw_steps[Step_index].line
  rescue Exception => e
    puts "#{Time.now} - Exception:#{e}"
  end
end

After do |scenario|
  #TODO
  sleep(2)
end

AfterStep do |scenario|
  #Håndtering af den situation hvor Feature/Scenario/steps er mulitline
  Step_index = Step_index + 1
  Step_line = scenario.raw_steps[Step_index].line unless scenario.raw_steps[Step_index].nil?
end