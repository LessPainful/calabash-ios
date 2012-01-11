WAIT_TIMEOUT = ENV['WAIT_TIMEOUT'] || 30
STEP_PAUSE = ENV['STEP_PAUSE'].to_f || 0.3

require 'rspec/expectations'

Given /^(my|the) app is running$/ do |_|
  #no-op on iOS
end


# -- Touch --#
Then /^I (press|touch) on screen (\d+) from the left and (\d+) from the top$/ do |_, x, y|
  touch(nil, {:x => x, :y => y})
  sleep(STEP_PAUSE)
end

Then /^I (press|touch) "([^\"]*)"$/ do |_,name|
  touch("view marked:'#{name}'")

  sleep(STEP_PAUSE)
end

#Then /^I (press|touch) (\d+)% right and (\d+)% down from "([^\"]*)" $/ do |_,x,y,name|
#  touch({:query => "view marked:'#{name}'", :offset => {:x => x, :y => y}})
#end

Then /^I (press|touch) button number (\d+)$/ do |_,index|
  index = index.to_i
  raise "Index should be positive (was: #{index})" if (index<=0)
  touch("button index:#{index-1}")
  sleep(STEP_PAUSE)
end

Then /^I (press|touch) the "([^\"]*)" button$/ do |_,name|
  touch("button marked:'#{name}'")
  sleep(STEP_PAUSE)
end

# /^I press view with name "([^\"]*)"$/
# like touch "..."
#  /^I press image button number (\d+)$/
# iOS doesn't have image buttons'

##TODO note in tables views: this means visible cell index!
Then /^I (press|touch) list item number (\d+)$/ do |_,index|
   index = index.to_i
   raise "Index should be positive (was: #{index})" if (index<=0)
   touch("tableViewCell index:#{index-1}")
   sleep(STEP_PAUSE)
end

Then /^I toggle the switch$/ do
  touch("view:'UISwitch'")
  sleep(STEP_PAUSE)
end

Then /^I toggle the "([^\"]*)" switch$/ do |name|
  touch("view:'UISwitch' marked:'#{name}'")
  sleep(STEP_PAUSE)
end

 #/^I enter "([^\"]*)" as "([^\"]*)"$/
## -- Entering text directly --##
When /^I enter "([^\"]*)" into the "([^\"]*)" text field$/ do |text_to_type, field_name|
  set_text("textField placeholder:'#{field_name}'", text_to_type)
  sleep(STEP_PAUSE)
end

# alias
When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |text_field, text_to_type|
  When %Q|I enter "#{text_to_type}" into the "#{text_field}" text field|
end

When /^I fill in text fields as follows:$/ do |table|
  table.hashes.each do |row|
    When %Q|I enter "#{row['text']}" into the "#{row['field']}" text field|
  end
end

Then /^I enter "([^\"]*)" into input field number (\d+)$/ do |text, index|
  index = index.to_i
  raise "Index should be positive (was: #{index})" if (index<=0)
  set_text("textField index:#{index-1}",text)
  sleep(STEP_PAUSE)
end

When /^I clear "([^\"]*)"$/ do |name|
  When %Q|I enter "" into the "#{name}" text field|
end

Then /^I clear input field number (\d+)$/ do |index|
  index = index.to_i
  raise "Index should be positive (was: #{index})" if (index<=0)
  set_text("textField index:#{index-1}","")
  sleep(STEP_PAUSE)
end




# -- See -- #
Then /^I wait to see "([^\"]*)"$/ do |expected_mark|
  Timeout::timeout(WAIT_TIMEOUT) do
    until view_with_mark_exists( expected_mark )
      sleep 0.3
    end
  end
end

Then /^I wait to not see "([^\"]*)"$/ do |expected_mark|
  sleep 2
  Timeout::timeout(WAIT_TIMEOUT) do
    while element_exists( "view marked:'#{expected_mark}'" )
      sleep 0.3
    end
  end
end

Then /^I wait for "([^\"]*)" to appear$/ do |name|
  Then %Q|I wait to see "#{name}"|
end

When /^I wait for ([\d\.]+) second(?:s)?$/ do |num_seconds|
  num_seconds = num_seconds.to_f
  sleep num_seconds
end
#/^I wait for dialog to close$/
#/^I wait for progress$/

Then /^I wait for the "([^\"]*)" button to appear$/ do |name|
  Timeout::timeout(WAIT_TIMEOUT) do
    until element_exists( "button marked:'#{name}'" )
      sleep 0.3
    end
  end
end

Then /^I wait to see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
    Timeout::timeout(30) do
      values = query('navigationItemView', :accessibilityLabel)
      until values.include?(expected_mark)
        values = query('navigationItemView', :accessibilityLabel)
        sleep 0.3
      end
    end
end

Then /^I wait$/ do
  sleep 2
end

Then /^I wait and wait$/ do
  sleep 4
end

Then /^I wait and wait and wait\.\.\.$/ do
  sleep 10
end

Then /^I go back$/ do
    touch("navigationItemButtonView first")
    sleep(STEP_PAUSE)
end

Then /^take picture$/ do
  sleep(STEP_PAUSE)
  screenshot
end

#   Note "up/down" seems to be missing on the web page?
#   Should be /^I swipe (left|right|up|down)$/
Then /^I swipe (left|right)$/ do |dir|
    swipe(dir)
    sleep(STEP_PAUSE)
end

Then /^I swipe (left|right) on "([^\"]*)"$/ do |dir, mark|
    swipe(dir, {:query => "view marked:'#{mark}'"})
    sleep(STEP_PAUSE)
end

Then /^I swipe on cell number (\d+)$/ do |index|
  index = index.to_i
  raise "Index should be positive (was: #{index})" if (index<=0)
  cell_swipe({:query => "tableViewCell index:#{index-1}"})
  sleep(STEP_PAUSE)
end


##pinch##
Then /^I pinch to zoom (in|out)$/ do |in_out|
  pinch(in_out)
  sleep([STEP_PAUSE+4,6].max)
end

Then /^I pinch to zoom (in|out) on "([^\"]*)"$/ do |in_out, name|
  pinch(in_out,{:query => "view marked:'#{name}'"})
  sleep([STEP_PAUSE+4,6].max)
end

#   Note "up/left/right" seems to be missing on the web page
Then /^I scroll (left|right|up|down)$/ do |dir|
  scroll("scrollView index:0", dir)
  sleep(STEP_PAUSE)
end

Then /^I scroll (left|right|up|down) on "([^\"]*)"$/ do |dir,name|
  scroll("view marked:'#{name}'", dir)
  sleep(STEP_PAUSE)
end



### Playback ###
Then /^I playback recording "([^"]*)"$/ do |filename|
    playback(filename)
    sleep(STEP_PAUSE)
end

Then /^I playback recording "([^"]*) on "([^"]*)"$/ do |filename, name|
    playback(filename, {:query => "view marked:'#{name}'"})
    sleep(STEP_PAUSE)
end

Then /^I playback recording "([^"]*) on "([^"]*)" with offset (\d+),(\d+)$/ do |filename, name, x, y|
  x = x.to_i
  y = y.to_i
  playback(filename, {:query => "view marked:'#{name}'", :offset => {:x => x, :y => y}})
  sleep(STEP_PAUSE)
end

Then /^I reverse playback recording "([^"]*)"$/ do |filename|
    playback(filename, {:reverse => true})
    sleep(STEP_PAUSE)
end

Then /^I reverse playback recording "([^"]*) on "([^"]*)"$/ do |filename, name|
    playback(filename, {:query => "view marked:'#{name}'",:reverse => true})
    sleep(STEP_PAUSE)
end

Then /^I reverse playback recording "([^"]*) on "([^"]*)" with offset (\d+),(\d+)$/ do |filename, name, x, y|
  x = x.to_i
  y = y.to_i
  playback(filename, {:query => "view marked:'#{name}'", :offset => {:x => x, :y => y},:reverse => true})
  sleep(STEP_PAUSE)
end


### Device orientation ###
Then /^I rotate device (left|right)$/ do |dir|
  dir = dir.to_sym
  rotate(dir)
  sleep(STEP_PAUSE)
end

Then /^I send app to background for (\d+) seconds$/ do |secs|
  secs = secs.to_f
  background(secs)
end

### Assertions ###
Then /^I should see "([^\"]*)"$/ do |expected_mark|
  res = (element_exists( "view marked:'#{expected_mark}'" ) ||
         element_exists( "view text:'#{expected_mark}'"))
  res.should be_true
end

Then /^I should not see "([^\"]*)"$/ do |expected_mark|
  check_element_does_not_exist("view marked:'#{expected_mark}'")
end

Then /^I should see a "([^\"]*)" button$/ do |expected_mark|
  check_element_exists("button marked:'#{expected_mark}'")
end
Then /^I should not see a "([^\"]*)" button$/ do |expected_mark|
  check_element_does_not_exist("button marked:'#{expected_mark}'")
end

Then /^I don't see the text "([^\"]*)"$/ do |text|
  Then %Q|I should not see "#{text}"|
end
Then /^I don't see the "([^\"]*)"$/ do |text|
  Then %Q|I should not see "#{text}"|
end

Then /^I see the text "([^\"]*)"$/ do |text|
  Then %Q|I should see "#{text}"|
end
Then /^I see the "([^\"]*)"$/ do |text|
  Then %Q|I should see "#{text}"|
end


Then /^I should see a map$/ do
  check_element_exists("view:'MKMapView'")
end

Then /^I touch user location$/ do
  touch("view:'MKUserLocationView'")
end

Then /^I (touch|press) (done|search)$/ do  |_,__|
  done
  sleep(STEP_PAUSE)
end

