CALABASH_COUNT = {:step_index => 0, :step_line => nil}

Before do |scenario|
  begin
    CALABASH_COUNT[:step_index] = 0
    CALABASH_COUNT[:step_line] = scenario.raw_steps[CALABASH_COUNT[:step_index]].line
  rescue Exception => e
    puts "#{Time.now} - Exception:#{e}"
  end
end

AfterStep do |scenario|
  #Håndtering af den situation hvor Feature/Scenario/steps er mulitline
  CALABASH_COUNT[:step_index] = CALABASH_COUNT[:step_index] + 1
  raw = scenario.raw_steps[CALABASH_COUNT[:step_index]]
  CALABASH_COUNT[:step_line] = raw.line unless raw.nil?
end