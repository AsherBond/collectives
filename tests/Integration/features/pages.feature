Feature: pages

  Scenario: Create collective and first page
    When user "jane" creates collective "BehatPagesCollective"
    And user "jane" creates page "firstpage" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "jane" creates page "secondpage" with parentPath "Readme.md" in "BehatPagesCollective"
    Then user "jane" sees pagePath "firstpage.md" in "BehatPagesCollective"

  Scenario: Upload and list attachment for page
    When user "jane" uploads attachment "test.png" to "firstpage" in "BehatPagesCollective"
    Then user "jane" sees attachment "test.png" with mimetype "image/png" for "firstpage" in "BehatPagesCollective"

  Scenario: Share collective (with pages) and create subpage
    When user "alice" joins circle "BehatPagesCollective" with owner "jane"
    And user "alice" creates page "subpage" with parentPath "firstpage.md" in "BehatPagesCollective"
    Then user "jane" sees pagePath "firstpage/subpage.md" in "BehatPagesCollective"
    And user "jane" doesn't see pagePath "firstpage.md" in "BehatPagesCollective"
    And user "jane" sees pagePath "firstpage/Readme.md" in "BehatPagesCollective"

  Scenario: Touch page
    When user "alice" touches page "firstpage" with parentPath "Readme.md" in "BehatPagesCollective"
    Then user "alice" last edited page "firstpage" in "BehatPagesCollective"

  Scenario: Create page with namespace conflict
    When user "alice" creates page "firstpage" with parentPath "Readme.md" in "BehatPagesCollective"
    Then user "alice" sees pagePath "firstpage (2).md" in "BehatPagesCollective"

  Scenario: Create another page with namespace conflict
    When user "jane" creates page "firstpage" with parentPath "Readme.md" in "BehatPagesCollective"
    Then user "jane" sees pagePath "firstpage (3).md" in "BehatPagesCollective"

  Scenario: Rename page
    When user "jane" renames page "firstpage (2)" to "subpage2" with parentPath "firstpage/Readme.md" in "BehatPagesCollective"
    Then user "jane" sees pagePath "firstpage/subpage2.md" in "BehatPagesCollective"
    And user "jane" doesn't see pagePath "firstpage (2).md" in "BehatPagesCollective"

  Scenario: Fails to rename landingpage
    When user "jane" fails to rename page "Readme" to "newnamepage" with parentPath "Readme.md" in "BehatPagesCollective"

  Scenario: Change page emoji
    When user "jane" sets emoji for page "firstpage" to "🍏" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "jane" sets emoji for page "firstpage" to "" with parentPath "Readme.md" in "BehatPagesCollective"

  Scenario: Change page subpageOrder
    When user "jane" sets subpageOrder for page "firstpage" to "[]" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "jane" sets subpageOrder for page "firstpage" to "[1,2]" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "jane" fails to set subpageOrder for page "firstpage" to "[invalid]" with parentPath "Readme.md" in "BehatPagesCollective"

  Scenario: Rename parent page
    When user "jane" renames page "firstpage" to "parentpage" with parentPath "Readme.md" in "BehatPagesCollective"
    Then user "jane" sees pagePath "parentpage/Readme.md" in "BehatPagesCollective"
    And user "jane" sees pagePath "parentpage/subpage.md" in "BehatPagesCollective"
    And user "jane" doesn't see pagePath "firstpage/subpage.md" in "BehatPagesCollective"
    And user "jane" doesn't see pagePath "firstpage/parentpage.md" in "BehatPagesCollective"

  Scenario: Create and use template page
    When user "jane" creates page "Template" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "jane" creates page "Subtemplate" with parentPath "Template.md" in "BehatPagesCollective"
    And user "jane" creates page "anotherpage" with parentPath "Readme.md" in "BehatPagesCollective"
    Then user "jane" sees pagePath "anotherpage/Subtemplate.md" in "BehatPagesCollective"

  Scenario: Trash subpage
    When user "jane" trashes page "subpage" with parentPath "parentpage/Readme.md" in "BehatPagesCollective"
    Then user "jane" doesn't see pagePath "parentpage/subpage.md" in "BehatPagesCollective"
    And user "jane" sees pagePath "parentpage/Readme.md" in "BehatPagesCollective"

  Scenario: Fail to restore+delete pages in read-only collective
    When user "alice" joins circle "BehatPagesCollective" with owner "jane"
    And user "jane" sets "edit" level in collective "BehatPagesCollective" to "Admin"
    Then user "alice" fails to restore page "subpage" from trash in "BehatPagesCollective"
    When user "alice" fails to delete page "subpage" from trash in "BehatPagesCollective"

  Scenario: Restore subpage
    When user "jane" restores page "subpage" from trash in "BehatPagesCollective"
    Then user "jane" sees pagePath "parentpage/subpage.md" in "BehatPagesCollective"

  Scenario: Trash and restore a page with subpages
    When user "jane" trashes page "parentpage" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "jane" doesn't see pagePath "parentpage/Readme.md" in "BehatPagesCollective"
    Then user "jane" restores page "parentpage" from trash in "BehatPagesCollective"

  Scenario: Trash and delete all subpages reverts subfolders
    When user "jane" trashes page "subpage" with parentPath "parentpage/Readme.md" in "BehatPagesCollective"
    And user "jane" trashes page "subpage2" with parentPath "parentpage/Readme.md" in "BehatPagesCollective"
    When user "jane" deletes page "subpage" from trash in "BehatPagesCollective"
    When user "jane" deletes page "subpage2" from trash in "BehatPagesCollective"
    Then user "jane" doesn't see pagePath "parentpage/Readme.md" in "BehatPagesCollective"
    And user "jane" sees pagePath "parentpage.md" in "BehatPagesCollective"

  Scenario: Fail to edit pages in read-only collective
    When user "john" joins circle "BehatPagesCollective" with owner "jane"
    And user "jane" sets "edit" level in collective "BehatPagesCollective" to "Admin"
    Then user "john" fails to create page "johnspage" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "john" fails to touch page "secondpage" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "john" fails to rename page "secondpage" to "newnamepage" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "john" fails to set emoji for page "secondpage" to "🍏" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "john" fails to set subpageOrder for page "secondpage" to "[]" with parentPath "Readme.md" in "BehatPagesCollective"
    And user "john" fails to trash page "secondpage" with parentPath "Readme.md" in "BehatPagesCollective"

  Scenario: Trash and delete collective and circle with all remaining pages
    Then user "jane" trashes collective "BehatPagesCollective"
    And user "jane" deletes collective+circle "BehatPagesCollective"
