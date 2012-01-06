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
  When %Q|I type "" into the "#{name}" text field|
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
end


#** TODO /^I dont see the text "([^\"]*)"$/
#   /^I dont see the "([^\"]*)"$/ do |text|
#
#   the ruby block is a copy-paste on the web.
#   I would say I should see and I should not see
#   seems more natural.
#
#   OK
#

#
#
#
#Then /I should see the following:/ do |table|
#  values = frankly_map( 'view', 'accessibilityLabel' )
#  table.raw.each do |expected_mark|
#    values.should include( expected_mark.first )
#  end
#end
#
#Then /I should not see the following:/ do |table|
#  values = frankly_map( 'view', 'accessibilityLabel' )
#  table.raw.each do |expected_mark|
#    values.should_not include( expected_mark.first )
#  end
#end
#
#Then /^I should see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
#  values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
#  values.should include(expected_mark)
#end
#
#Then /^I should see an alert view titled "([^\"]*)"$/ do |expected_mark|
#  values = frankly_map( 'alertView', 'message')
#  puts values
#  values.should include(expected_mark)
#end
#
#Then /^I should not see an alert view$/ do
#  check_element_does_not_exist( 'alertView' )
#end
#
#Then /^I should see an element of class "([^\"]*)" with name "([^\"]*)" with the following labels: "([^\"]*)"$/ do |className, classLabel, listOfLabels|
#	arrayOfLabels = listOfLabels.split(',');
#	arrayOfLabels.each do |label|
#		check_element_exists("view marked:'#{classLabel}' parent view:'#{className}' descendant view marked:'#{label}'")
#	end
#end
#
#Then /^I should see an element of class "([^\"]*)" with name "([^\"]*)" with a "([^\"]*)" button$/ do |className, classLabel, buttonName|
#	check_element_exists("view marked:'#{classLabel}' parent view:'#{className}' descendant button marked:'#{buttonName}'")
#end
#
#Then /^I should not see a hidden button marked "([^\"]*)"$/ do |expected_mark|
#  element_is_not_hidden("button marked:'#{expected_mark}'").should be_false
#end
#
#Then /^I should see a nonhidden button marked "([^\"]*)"$/ do |expected_mark|
#  element_is_not_hidden("button marked:'#{expected_mark}'").should be_true
#end
#
#Then /^I should see an element of class "([^\"]*)"$/ do |className|
#	element_is_not_hidden("view:'#{className}'")
#end
#
#Then /^I should not see an element of class "([^\"]*)"$/ do |className|
#  selector = "view:'#{className}'"
#  element_exists_and_is_not_hidden = element_exists( selector ) && element_is_not_hidden(selector)
#  element_exists_and_is_not_hidden.should be_false
#end
#
#
## -- Type/Fill in -- #
#
#When /^I type "([^\"]*)" into the "([^\"]*)" text field$/ do |text_to_type, field_name|
#  text_fields_modified = frankly_map( "textField placeholder:'#{field_name}'", "setText:", text_to_type )
#  raise "could not find text fields with placeholder '#{field_name}'" if text_fields_modified.empty?
#  #TODO raise warning if text_fields_modified.count > 1
#end
#
## alias
#When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |text_field, text_to_type|
#  puts %Q|I type "#{text_to_type}" into the "#{text_field}" text field|
#  When %Q|I type "#{text_to_type}" into the "#{text_field}" text field|
#end
#
#When /^I fill in text fields as follows:$/ do |table|
#  table.hashes.each do |row|
#    When %Q|I type "#{row['text']}" into the "#{row['field']}" text field|
#  end
#end
#
## -- Rotate -- #
#Given /^the device is in (a )?landscape orientation$/ do |ignored|
#  # for some reason the simulator sometimes starts of reporting its orientation as 'flat'. Workaround for this is to rotate the device then wait a bit
#  if 'flat' == frankly_current_orientation
#    rotate_simulator_right
#    sleep 1
#  end
#
#  unless frankly_oriented_landscape?
#    rotate_simulator_left
#    sleep 1
#    raise "expected orientation to be landscape after rotating left, but it is #{frankly_current_orientation}" unless frankly_oriented_landscape?
#  end
#end
#
#Given /^the device is in (a )?portrait orientation$/ do |ignored|
#  # for some reason the simulator sometimes starts of reporting its orientation as 'flat'. Workaround for this is to rotate the device then wait a bit
#  if 'flat' == frankly_current_orientation
#    rotate_simulator_right
#    sleep 1
#  end
#
#  unless frankly_oriented_portrait?
#    rotate_simulator_left
#    sleep 1
#    raise "Expected orientation to be portrait after rotating left, but it is #{frankly_current_orientation}" unless frankly_oriented_portrait?
#  end
#end
#
#When /^I simulate a memory warning$/ do
#  simulate_memory_warning
#end
#
#Then /^I rotate to the "([^\"]*)"$/ do |direction|
#  if direction == "right"
#    rotate_simulator_right
#  elsif direction == "left"
#    rotate_simulator_left
#  else
#    raise %Q|Rotation direction specified ("#{direction}") is invalid. Please specify right or left.|
#  end
#  sleep 1
#end
#
## -- touch -- #
#When /^I touch "([^\"]*)"$/ do |mark|
#  selector = "view marked:'#{mark}' first"
#  if element_exists(selector)
#     touch( selector )
#  else
#     raise "Could not touch [#{mark}], it does not exist."
#  end
#  sleep 1
#end
#
#When /^I touch "([^\"]*)" if exists$/ do |mark|
#  sleep 1
#  selector = "view marked:'#{mark}' first"
#  if element_exists(selector)
#  	touch(selector)
#    sleep 1
#  end
#end
#
#When /^I touch the first table cell$/ do
#    touch("tableViewCell first")
#end
#
#When /^I swipe the first table cell?/ do
#  swipe( "tableViewCell index:0", :right)
#  sleep 2 # give the UI a chance to animate the swipe
#end
#
#
#When /^I touch the table cell marked "([^\"]*)"$/ do |mark|
#  touch("tableViewCell marked:'#{mark}'")
#end
#
#When /^I swipe the table cell marked "([^\"]*)"$/ do |cell_index_s|
#  swipe( "tableViewCell marked:'#{mark}'", :right)
#  sleep 2 # give the UI a chance to animate the swipe
#end
#
#
#When /^I touch the (\d*)(?:st|nd|rd|th)? table cell$/ do |ordinal|
#    ordinal = ordinal.to_i - 1
#    touch("tableViewCell index:#{ordinal}")
#
#end
#
#
#When /^I swipe the (\d*)(?:st|nd|rd|th)? table cell?/ do |cell_index_s|
#  cell_index = cell_index_s.to_i - 1 #index 0 corresponds to 1st
#  raise "Row should have a positive index" if cell_index <= 0
#  swipe( "tableViewCell index:#{cell_index}", :right)
#  sleep 2 # give the UI a chance to animate the swipe
#end
#
#
#Then /I touch the following:/ do |table|
#  values = frankly_map( 'view', 'accessibilityLabel' )
#  table.raw.each do |expected_mark|
#    touch( "view marked:'#{expected_mark}'" )
#    sleep 2
#  end
#end
#
#When /^I touch the button marked "([^\"]*)"$/ do |mark|
#  touch( "button marked:'#{mark}'" )
#end
#
#When /^I touch the "([^\"]*)" action sheet button$/ do |mark|
#  touch( "actionSheet threePartButton marked:'#{mark}'" )
#end
#
#When /^I touch the (\d*)(?:st|nd|rd|th)? action sheet button$/ do |ordinal|
#  ordinal = ordinal.to_i
#  touch( "actionSheet threePartButton tag:#{ordinal}" )
#end
#
#When /^I touch the (\d*)(?:st|nd|rd|th)? alert view button$/ do |ordinal|
#  ordinal = ordinal.to_i
#  touch( "alertView threePartButton tag:#{ordinal}" )
#end
#
## -- switch -- #
#
#When /^I flip switch "([^\"]*)" on$/ do |mark|
#  selector = "view:'UISwitch' marked:'#{mark}'"
#  views_switched = frankly_map( selector, 'setOn:animated:', true, true )
#  raise "could not find anything matching [#{uiquery}] to switch" if views_switched.empty?
#end
#
#When /^I flip switch "([^\"]*)" off$/ do |mark|
#  selector = "view:'UISwitch' marked:'#{mark}'"
#  views_switched = frankly_map( selector, 'setOn:animated:', false, true )
#  raise "could not find anything matching [#{uiquery}] to switch" if views_switched.empty?
#end
#
#When /^I flip switch "([^\"]*)"$/ do |mark|
#  touch("view:'UISwitch' marked:'#{mark}'")
#end
#
#Then /^switch "([^\"]*)" should be on$/ do |mark|
##  switch_states = frankly_map( "view:'Switch' marked:'#{mark}'", "isOn" )
#  switch_states = frankly_map( "view accesibilityLabel:'#{mark}'", "isOn" )
#  puts "test #{switch_states.inspect}"
#
#  if switch_states == 0
#    puts "Switch #{mark} is ON"
#  else
#    puts "Switch #{mark} is OFF, flim switch ON"
#    Then %Q|I flip switch "#{mark}"|
#  end
#end
#
#Then /^switch "([^\"]*)" should be off$/ do |mark|
#  switch_states = frankly_map( "view:'UISwitch' marked:'#{mark}'", "isOn" )
#  puts "test #{switch_states.inspect}"
#
#  if switch_states == 0
#    puts "Switch #{mark} is ON, flip switch OFF"
#    Then %Q|I flip switch "#{mark}"|
#  else
#    puts "Switch #{mark} is OFF"
#  end
#end
#
#
## -- misc -- #
#
#When /^I wait for ([\d\.]+) second(?:s)?$/ do |num_seconds|
#  num_seconds = num_seconds.to_f
#  sleep num_seconds
#end
#
#Then /^a pop\-over menu is displayed with the following:$/ do |table|
#  sleep 1
#  table.raw.each do |expected_mark|
#    check_element_exists "actionSheet view marked:'#{expected_mark}'"
#  end
#end
#
#Then /^I navigate back$/ do
#  touch( "navigationItemButtonView" )
#end
#
#When /^I dump the DOM$/ do
#  dom = frankly_dump
#end
#
#When /^I touch Done$/ do
#    frankly_map('kBKeyView last','touch')
#end
#When /^I touch Next$/ do
#    frankly_map('kBKeyView last','touch')
#end
#
#When /^I quit the simulator/ do
#  quit_simulator
#end
