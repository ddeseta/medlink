Feature: Visit "Settings" Web Page
  As a visitor to the website
  I want to see everything that I expect on the settings page
  so I can know that the site is working

  Scenario: Check stuff on "Settings" page
    When I go to the settings page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"
#U#    Then I should see "United States"

#U#    Then I should see "Settings" inside "a"
    Then I should see "Help" inside "a"
#U#    Then I should see "Logout" inside "a"

#U#    Then I should see "Al Snow"
#U#    Then I should see "12345678"
#U#    Then I should see "jasnow@hotmail.com" (Name/placeholder)
#U#    Then I should see "4049390122" (Phone/placeholder)
#U#    Then I should see "Roswell" (City/placeholder)
#U#    Then I should see "Current Password" (placeholder)
#U#    Then I should see "New Password" (placeholder)
#U#    Then I should see "Password Confirmation" (placeholder)
