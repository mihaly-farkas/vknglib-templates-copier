Feature: Generating a new project from the Copier template

  Scenario: Generating a project with the default values
    Given an empty ".tmp/default" directory
    When I generate a new copy from the "." template to the ".tmp/default" directory
    Then the contents of the ".tmp/default" directory should be the same as the contents in the "features/fixtures/projects/default" directory with excludes
      | Exclude                       |
      | .release-please-manifest.json |
      | .tmp                          |
      | CHANGELOG.md                  |
